import 'package:meta/meta.dart';
import 'package:al_anime_creator/features/data/models/story.dart';

@immutable
sealed class StoryGenerationState {}

final class StoryGenerationInitial extends StoryGenerationState {
  final String? characterDetails;
  final String? settingDetails;
  final String? plotDetails;
  final String? emotionDetails;
  final int selectedLength; // 0: Short, 1: Mid, 2: Long
  final double sliderValue; // -1: Standard, 0: Complex, 1: Creative

  StoryGenerationInitial({
    this.characterDetails = '',
    this.settingDetails = '',
    this.plotDetails = '',
    this.emotionDetails = '',
    this.selectedLength = 1,
    this.sliderValue = 0,
  });

  StoryGenerationInitial copyWith({
    String? characterDetails,
    String? settingDetails,
    String? plotDetails,
    String? emotionDetails,
    int? selectedLength,
    double? sliderValue,
  }) {
    return StoryGenerationInitial(
      characterDetails: characterDetails ?? this.characterDetails,
      settingDetails: settingDetails ?? this.settingDetails,
      plotDetails: plotDetails ?? this.plotDetails,
      emotionDetails: emotionDetails ?? this.emotionDetails,
      selectedLength: selectedLength ?? this.selectedLength,
      sliderValue: sliderValue ?? this.sliderValue,
    );
  }
}

class StoryGenerationLoading extends StoryGenerationState {}

class StoryGenerationLoaded extends StoryGenerationState {
  final String generatedStory;
  final Story savedStory;

  StoryGenerationLoaded(this.generatedStory, this.savedStory);
}

class StoryGenerationError extends StoryGenerationState {
  final String message;
  final StoryGenerationInitial? previousState;

  StoryGenerationError(this.message, {this.previousState});
}