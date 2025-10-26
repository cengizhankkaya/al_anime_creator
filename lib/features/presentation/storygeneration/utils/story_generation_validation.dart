import 'package:al_anime_creator/features/data/models/story_generation_constants.dart';

class StoryGenerationValidation {
  static String? validateCharacterDetails(String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < StoryGenerationConstants.minCharacterDetailsLength) {
      return 'Karakter detayları en az ${StoryGenerationConstants.minCharacterDetailsLength} karakter olmalıdır';
    }
    
    if (value.length > StoryGenerationConstants.maxCharacterDetailsLength) {
      return 'Karakter detayları en fazla ${StoryGenerationConstants.maxCharacterDetailsLength} karakter olabilir';
    }
    
    return null;
  }

  static String? validateSettingDetails(String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < StoryGenerationConstants.minSettingDetailsLength) {
      return 'Mekan detayları en az ${StoryGenerationConstants.minSettingDetailsLength} karakter olmalıdır';
    }
    
    if (value.length > StoryGenerationConstants.maxSettingDetailsLength) {
      return 'Mekan detayları en fazla ${StoryGenerationConstants.maxSettingDetailsLength} karakter olabilir';
    }
    
    return null;
  }

  static String? validatePlotDetails(String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < StoryGenerationConstants.minPlotDetailsLength) {
      return 'Olay örgüsü en az ${StoryGenerationConstants.minPlotDetailsLength} karakter olmalıdır';
    }
    
    if (value.length > StoryGenerationConstants.maxPlotDetailsLength) {
      return 'Olay örgüsü en fazla ${StoryGenerationConstants.maxPlotDetailsLength} karakter olabilir';
    }
    
    return null;
  }

  static String? validateEmotionDetails(String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < StoryGenerationConstants.minEmotionDetailsLength) {
      return 'Duygu detayları en az ${StoryGenerationConstants.minEmotionDetailsLength} karakter olmalıdır';
    }
    
    if (value.length > StoryGenerationConstants.maxEmotionDetailsLength) {
      return 'Duygu detayları en fazla ${StoryGenerationConstants.maxEmotionDetailsLength} karakter olabilir';
    }
    
    return null;
  }

  static bool hasAtLeastOneInput(String? characterDetails, String? settingDetails, String? plotDetails, String? emotionDetails) {
    return (characterDetails?.isNotEmpty ?? false) ||
           (settingDetails?.isNotEmpty ?? false) ||
           (plotDetails?.isNotEmpty ?? false) ||
           (emotionDetails?.isNotEmpty ?? false);
  }
}
