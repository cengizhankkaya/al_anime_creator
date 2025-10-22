enum StoryLength {
  short(0, 'Kısa'),
  mid(1, 'Orta'),
  long(2, 'Uzun');

  const StoryLength(this.value, this.displayName);
  final int value;
  final String displayName;

  static StoryLength fromValue(int value) {
    return StoryLength.values.firstWhere(
      (length) => length.value == value,
      orElse: () => StoryLength.mid,
    );
  }
}

enum CreativityLevel {
  standard(-1.0, 'Standart'),
  complex(0.0, 'Karmaşık'),
  creative(1.0, 'Yaratıcı');

  const CreativityLevel(this.value, this.displayName);
  final double value;
  final String displayName;

  static CreativityLevel fromSliderValue(double sliderValue) {
    if (sliderValue <= -0.3) return CreativityLevel.standard;
    if (sliderValue >= 0.3) return CreativityLevel.creative;
    return CreativityLevel.complex;
  }
}

class StoryGenerationConstants {
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const String defaultStoryTitle = 'AI Generated Story';
  static const String defaultChapterTitle = 'Chapter 1';
  
  // Validation constants
  static const int minCharacterDetailsLength = 3;
  static const int maxCharacterDetailsLength = 500;
  static const int minSettingDetailsLength = 3;
  static const int maxSettingDetailsLength = 500;
  static const int minPlotDetailsLength = 3;
  static const int maxPlotDetailsLength = 500;
  static const int minEmotionDetailsLength = 3;
  static const int maxEmotionDetailsLength = 500;
}
