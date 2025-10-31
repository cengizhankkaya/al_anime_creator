import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/data/models/story_generation_constants.dart';
import 'package:al_anime_creator/features/data/models/story_generation_params.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/utils/story_generation_error_handler.dart';

abstract class AIService {
  Future<String> generateStory(StoryGenerationParams params);
  Future<String> continueStory(Story existingStory, String continuationPrompt);
  Future<String> autoContinueStory(Story existingStory);
}

class AIServiceImpl implements AIService {
  final GenerativeModel _model;

  AIServiceImpl(this._model);

  @override
  Future<String> generateStory(StoryGenerationParams params) async {
    try {
      final Map<int, String> lengthMap = {
        0: 'kısa',
        1: 'orta uzunlukta',
        2: 'uzun'
      };
      final String storyLength = lengthMap[params.selectedLength] ?? 'orta uzunlukta';

      String creativityLevel;
      if (params.sliderValue <= -0.3) {
        creativityLevel = 'standart';
      } else if (params.sliderValue >= 0.3) {
        creativityLevel = 'yaratıcı';
      } else {
        creativityLevel = 'karmaşık';
      }

      final String prompt = '''
      Türkçe bir hikaye oluştur. Hikaye şu özelliklerde olsun:

      Hikaye Uzunluğu: $storyLength
      Yaratıcılık Seviyesi: $creativityLevel

      ${params.characterDetails.isNotEmpty ? 'Karakter Detayları: ${params.characterDetails}' : ''}
      ${params.settingDetails.isNotEmpty ? 'Mekan ve Ortam: ${params.settingDetails}' : ''}
      ${params.plotDetails.isNotEmpty ? 'Olay Örgüsü: ${params.plotDetails}' : ''}
      ${params.emotionDetails.isNotEmpty ? 'Duygu ve Ton: ${params.emotionDetails}' : ''}

      Hikaye anime tarzında, sürükleyici ve görsel olarak zengin olsun. Türkçe yaz.
      
      ÖNEMLİ: Hikayede markdown formatı (örneğin *, # gibi işaretler) kullanma. Sadece düz metin olarak yaz.
      ''';

      final Content content = Content.text(prompt);
      final response = await _model.generateContent([content])
          .timeout(StoryGenerationConstants.requestTimeout);

      return response.text ?? "Üzgünüm, bir hikaye oluşturamadım.";
    } catch (e) {
      throw Exception(StoryGenerationErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<String> continueStory(Story existingStory, String continuationPrompt) async {
    try {
      final lastChapter = existingStory.chapters.last;
      final String prompt = '''
      Bu hikayenin devamını yaz. Mevcut hikaye şu şekilde:

      Hikaye Başlığı: ${existingStory.title}
      
      Son Bölüm:
      ${lastChapter.content}

      Hikaye Ayarları:
      - Uzunluk: ${existingStory.settings.length}
      - Karmaşıklık: ${existingStory.settings.complexity}
      ${existingStory.settings.characterDetails.isNotEmpty ? '- Karakter Detayları: ${existingStory.settings.characterDetails}' : ''}
      ${existingStory.settings.settingEnvironment.isNotEmpty ? '- Mekan ve Ortam: ${existingStory.settings.settingEnvironment}' : ''}
      ${existingStory.settings.plotStructure.isNotEmpty ? '- Olay Örgüsü: ${existingStory.settings.plotStructure}' : ''}
      ${existingStory.settings.emotionsTone.isNotEmpty ? '- Duygu ve Ton: ${existingStory.settings.emotionsTone}' : ''}

      Kullanıcı İsteği: $continuationPrompt

      Lütfen hikayenin devamını yaz. Mevcut karakterleri, ortamı ve hikaye tonunu koruyarak devam et. 
      Anime tarzında, sürükleyici ve görsel olarak zengin olsun. Türkçe yaz.
      
      ÖNEMLİ: Hikayede markdown formatı (örneğin *, # gibi işaretler) kullanma. Sadece düz metin olarak yaz.
      ''';

      final Content content = Content.text(prompt);
      final response = await _model.generateContent([content])
          .timeout(StoryGenerationConstants.requestTimeout);

      return response.text ?? "Üzgünüm, hikayenin devamını oluşturamadım.";
    } catch (e) {
      throw Exception(StoryGenerationErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<String> autoContinueStory(Story existingStory) async {
    try {
      final allContent = existingStory.chapters.map((chapter) => chapter.content).join('\n\n');
      final lastChapter = existingStory.chapters.last;

      final String prompt = '''
      Bu uzun hikayenin devamını otomatik olarak yaz. Hikayeyi analiz edip mantıklı bir şekilde devam ettir.

      Hikaye Başlığı: ${existingStory.title}
      
      Hikaye Özeti (İlk bölümlerden):
      ${allContent.length > 1000 ? allContent.substring(0, 1000) + '...' : allContent}
      
      Son Bölüm:
      ${lastChapter.content}

      Hikaye Ayarları:
      - Uzunluk: ${existingStory.settings.length}
      - Karmaşıklık: ${existingStory.settings.complexity}
      ${existingStory.settings.characterDetails.isNotEmpty ? '- Karakter Detayları: ${existingStory.settings.characterDetails}' : ''}
      ${existingStory.settings.settingEnvironment.isNotEmpty ? '- Mekan ve Ortam: ${existingStory.settings.settingEnvironment}' : ''}
      ${existingStory.settings.plotStructure.isNotEmpty ? '- Olay Örgüsü: ${existingStory.settings.plotStructure}' : ''}
      ${existingStory.settings.emotionsTone.isNotEmpty ? '- Duygu ve Ton: ${existingStory.settings.emotionsTone}' : ''}

      Görevler:
      1. Hikayenin mevcut karakterlerini, ortamını ve tonunu analiz et
      2. Son bölümdeki olayların mantıklı devamını yaz
      3. Hikayenin genel akışını ve temalarını koru
      4. Yeni ilginç olaylar ve karakter gelişimleri ekle
      5. Uzun hikaye formatına uygun detaylı ve sürükleyici içerik üret

      Lütfen hikayenin doğal devamını yaz. Anime tarzında, görsel olarak zengin ve sürükleyici olsun. Türkçe yaz.
      
      ÖNEMLİ: Hikayede markdown formatı (örneğin *, # gibi işaretler) kullanma. Sadece düz metin olarak yaz.
      ''';

      final Content content = Content.text(prompt);
      final response = await _model.generateContent([content])
          .timeout(StoryGenerationConstants.requestTimeout);

      return response.text ?? "Üzgünüm, hikayenin otomatik devamını oluşturamadım.";
    } catch (e) {
      throw Exception(StoryGenerationErrorHandler.getErrorMessage(e));
    }
  }
}
