

import 'package:al_anime_creator/features/storyHistory/view_model/story_history_viewmodel.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storygeneration/service/ai_service.dart';
import 'package:al_anime_creator/product/service/firestore_service.dart';
import 'package:uuid/uuid.dart';

abstract class StoryGenerationRepository {
  Future<Story> generateAndSaveStory(StoryGenerationParams params);
}

class StoryGenerationRepositoryImpl implements StoryGenerationRepository {
  final AIService _aiService;
  final StoryHistoryViewModel _historyViewModel;
  final FirestoreService _firestoreService;

  StoryGenerationRepositoryImpl(
    this._aiService, 
    this._historyViewModel,
    this._firestoreService,
  );

  @override
  Future<Story> generateAndSaveStory(StoryGenerationParams params) async {
    // AI'den hikaye üret
    final storyContent = await _aiService.generateStory(params);
    
    // Hikaye objesini oluştur
    final newStory = _createStoryFromContent(storyContent, params);
    
    // Firebase'e kaydet
    await _firestoreService.saveStory(newStory);
    
    // Local ViewModel'e de ekle
    _historyViewModel.addStory(newStory);
    
    return newStory;
  }

  Story _createStoryFromContent(String content, StoryGenerationParams params) {
    try {
      // Hikaye başlığını oluştur (ilk cümleden)
      String title = 'AI Generated Story';
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
            title: 'Chapter 1',
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