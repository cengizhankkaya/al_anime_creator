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

  Map<String, dynamic> toMap() {
    return {
      'characterDetails': characterDetails,
      'settingDetails': settingDetails,
      'plotDetails': plotDetails,
      'emotionDetails': emotionDetails,
      'selectedLength': selectedLength,
      'sliderValue': sliderValue,
    };
  }

  factory StoryGenerationParams.fromMap(Map<String, dynamic> map) {
    return StoryGenerationParams(
      characterDetails: map['characterDetails'] ?? '',
      settingDetails: map['settingDetails'] ?? '',
      plotDetails: map['plotDetails'] ?? '',
      emotionDetails: map['emotionDetails'] ?? '',
      selectedLength: map['selectedLength'] ?? 1,
      sliderValue: map['sliderValue']?.toDouble() ?? 0.0,
    );
  }

  StoryGenerationParams copyWith({
    String? characterDetails,
    String? settingDetails,
    String? plotDetails,
    String? emotionDetails,
    int? selectedLength,
    double? sliderValue,
  }) {
    return StoryGenerationParams(
      characterDetails: characterDetails ?? this.characterDetails,
      settingDetails: settingDetails ?? this.settingDetails,
      plotDetails: plotDetails ?? this.plotDetails,
      emotionDetails: emotionDetails ?? this.emotionDetails,
      selectedLength: selectedLength ?? this.selectedLength,
      sliderValue: sliderValue ?? this.sliderValue,
    );
  }
}
