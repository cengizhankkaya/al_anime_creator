import 'package:firebase_ai/firebase_ai.dart';

abstract class AIService {
  Future<String> generateStory(StoryGenerationParams params);
}

class AIServiceImpl implements AIService {
  final GenerativeModel _model;

  AIServiceImpl(this._model);

  @override
  Future<String> generateStory(StoryGenerationParams params) async {
    try {
      // Hikaye uzunluğunu belirle
      final Map<int, String> lengthMap = {
        0: 'kısa',
        1: 'orta uzunlukta',
        2: 'uzun'
      };
      final String storyLength = lengthMap[params.selectedLength] ?? 'orta uzunlukta';

      // Yaratıcılık seviyesini belirle
      String creativityLevel;
      if (params.sliderValue <= -0.3) {
        creativityLevel = 'standart';
      } else if (params.sliderValue >= 0.3) {
        creativityLevel = 'yaratıcı';
      } else {
        creativityLevel = 'karmaşık';
      }

      // Hikaye oluşturma prompt'unu hazırla
      final String prompt = '''
      Türkçe bir hikaye oluştur. Hikaye şu özelliklerde olsun:

      Hikaye Uzunluğu: $storyLength
      Yaratıcılık Seviyesi: $creativityLevel

      ${params.characterDetails.isNotEmpty ? 'Karakter Detayları: ${params.characterDetails}' : ''}
      ${params.settingDetails.isNotEmpty ? 'Mekan ve Ortam: ${params.settingDetails}' : ''}
      ${params.plotDetails.isNotEmpty ? 'Olay Örgüsü: ${params.plotDetails}' : ''}
      ${params.emotionDetails.isNotEmpty ? 'Duygu ve Ton: ${params.emotionDetails}' : ''}

      Hikaye anime tarzında, sürükleyici ve görsel olarak zengin olsun. Türkçe yaz.
      ''';

      // Gemini AI'ye gönder
      final Content content = Content.text(prompt);
      final response = await _model.generateContent([content])
          .timeout(const Duration(seconds: 30));

      return response.text ?? "Üzgünüm, bir hikaye oluşturamadım.";

    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('İstek zaman aşımına uğradı. Lütfen tekrar deneyin.');
      } else if (e.toString().contains('network')) {
        throw Exception('İnternet bağlantınızı kontrol edin.');
      } else {
        throw Exception('Hikaye oluşturulurken hata oluştu: $e');
      }
    }
  }
}

class StoryGenerationParams {
  final String characterDetails;
  final String settingDetails;
  final String plotDetails;
  final String emotionDetails;
  final int selectedLength;
  final double sliderValue;

  StoryGenerationParams({
    required this.characterDetails,
    required this.settingDetails,
    required this.plotDetails,
    required this.emotionDetails,
    required this.selectedLength,
    required this.sliderValue,
  });
}