

import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/data/models/story_generation_constants.dart';
import 'package:al_anime_creator/features/data/models/story_generation_params.dart';
import 'package:al_anime_creator/features/core/network/ai_service.dart';
import 'package:al_anime_creator/features/core/network/firestore_service.dart';

import 'package:uuid/uuid.dart';

abstract class StoryGenerationRepository {
  Future<Story> generateAndSaveStory(StoryGenerationParams params);
  Future<Story> continueStory(Story existingStory, String continuationPrompt);
  Future<Story> autoContinueStory(Story existingStory);
}

class StoryGenerationRepositoryImpl implements StoryGenerationRepository {
  final AIService _aiService;
  final FirestoreService _firestoreService;

  StoryGenerationRepositoryImpl(
    this._aiService,
    this._firestoreService,
  );

  @override
  Future<Story> generateAndSaveStory(StoryGenerationParams params) async {
    // AI'den hikaye üret
    final storyContentRaw = await _aiService.generateStory(params);
    final storyContent = _sanitizeContent(storyContentRaw);
    
    // Hikaye objesini oluştur
    final newStory = _createStoryFromContent(storyContent, params);
    
    // Firebase'e kaydet
    await _firestoreService.saveStory(newStory);
    
    return newStory;
  }

  @override
  Future<Story> continueStory(Story existingStory, String continuationPrompt) async {
    // AI'den hikaye devamını üret
    final continuationContentRaw = await _aiService.continueStory(existingStory, continuationPrompt);
    final continuationContent = _sanitizeContent(continuationContentRaw);
    
    // Yeni bölüm oluştur
    final newChapter = Chapter(
      id: const Uuid().v4(),
      title: 'Bölüm ${existingStory.chapters.length + 1}',
      content: continuationContent,
      chapterNumber: existingStory.chapters.length + 1,
    );
    
    // Mevcut hikayeye yeni bölümü ekle
    final updatedChapters = List<Chapter>.from(existingStory.chapters)..add(newChapter);
    final updatedStory = existingStory.copyWith(chapters: updatedChapters);
    
    // Firebase'e güncellenmiş hikayeyi kaydet
    await _firestoreService.updateStory(updatedStory);
    
    return updatedStory;
  }

  @override
  Future<Story> autoContinueStory(Story existingStory) async {
    // Sadece Long hikayeler için otomatik devam ettirme
    if (existingStory.settings.length.toLowerCase() != 'long') {
      throw Exception('Otomatik devam ettirme sadece Long hikayeler için kullanılabilir');
    }

    // AI'den otomatik hikaye devamını üret
    final continuationContentRaw = await _aiService.autoContinueStory(existingStory);
    final continuationContent = _sanitizeContent(continuationContentRaw);
    
    // Yeni bölüm oluştur
    final newChapter = Chapter(
      id: const Uuid().v4(),
      title: 'Bölüm ${existingStory.chapters.length + 1}',
      content: continuationContent,
      chapterNumber: existingStory.chapters.length + 1,
    );
    
    // Mevcut hikayeye yeni bölümü ekle
    final updatedChapters = List<Chapter>.from(existingStory.chapters)..add(newChapter);
    final updatedStory = existingStory.copyWith(chapters: updatedChapters);
    
    // Firebase'e güncellenmiş hikayeyi kaydet
    await _firestoreService.updateStory(updatedStory);
    
    return updatedStory;
  }

  /// AI cevabındaki gereksiz giriş cümlelerini temizler
  String _sanitizeContent(String content) {
    String text = content.trim();

    final List<RegExp> leadingPreamblePatterns = [
      // Türkçe yaygın kalıplar
      RegExp(r'^\s*(tamamdır[,!\.]?\s*)?(işte\s*(isted[iı]ğin(?:iz)?\s*özelliklerde[,!\.]?\s*)?(anime\s*tarz[ıi]nda\s*)?(bir\s*)?hikaye\s*:\s*)', caseSensitive: false, dotAll: true),
      RegExp(r'^\s*(işte\s*(bir\s*)?hikaye\s*:\s*)', caseSensitive: false, dotAll: true),
      // İngilizce olası kalıplar
      RegExp(r"^\s*(sure[,!\.]?\s*)?(here\'?s\s*(an?|the)?\s*.*story\s*:\s*)", caseSensitive: false, dotAll: true),
    ];

    for (final pattern in leadingPreamblePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        text = text.replaceFirst(pattern, '');
        break;
      }
    }

    // Eğer ilk satır tamamen açıklama cümlesiyse ve ardından boş satır geliyorsa onu da at
    final lines = text.split('\n');
    if (lines.isNotEmpty && lines.first.trim().length < 120) {
      final first = lines.first.trim().toLowerCase();
      if ((first.contains('hikaye') || first.contains('story')) && first.endsWith(':')) {
        text = lines.skip(1).join('\n');
      }
    }

    return text.trimLeft();
  }

  Story _createStoryFromContent(String content, StoryGenerationParams params) {
    try {
      // Hikaye başlığını oluştur (ilk cümleden)
      String title = StoryGenerationConstants.defaultStoryTitle;
      if (content.length > 50) {
        final firstSentence = content.split('.').first;
        if (firstSentence.length > 10) {
          title = firstSentence.substring(0, firstSentence.length > 50 ? 50 : firstSentence.length) + '...';
        }
      }

      // Hikaye ayarlarını topla
      final Map<int, String> lengthMap = {
        0: 'Short',
        1: 'Mid',
        2: 'Long'
      };
      final String storyLength = lengthMap[params.selectedLength] ?? 'Mid';

      String creativityLevel;
      if (params.sliderValue <= -0.3) {
        creativityLevel = 'Standard';
      } else if (params.sliderValue >= 0.3) {
        creativityLevel = 'Creative';
      } else {
        creativityLevel = 'Complex';
      }

      // Yeni hikaye oluştur
      final Story newStory = Story(
        id: const Uuid().v4(),
        title: title,
        chapters: [
          Chapter(
            id: const Uuid().v4(),
            title: StoryGenerationConstants.defaultChapterTitle,
            content: content,
            chapterNumber: 1,
          ),
        ],
        createdAt: DateTime.now(),
        settings: StorySettings(
          length: storyLength,
          complexity: creativityLevel,
          characterDetails: params.characterDetails,
          settingEnvironment: params.settingDetails,
          plotStructure: params.plotDetails,
          emotionsTone: params.emotionDetails,
        ),
      );

      return newStory;

    } catch (e) {
      throw Exception('Hikaye kaydedilirken hata oluştu: $e');
    }
  }
}