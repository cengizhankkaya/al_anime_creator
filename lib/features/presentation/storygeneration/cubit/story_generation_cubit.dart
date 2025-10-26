import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/data/repository/story_generation_repository.dart';
import 'package:al_anime_creator/features/data/models/story_generation_params.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/utils/story_generation_validation.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/utils/story_generation_error_handler.dart';

class StoryGenerationCubit extends Cubit<StoryGenerationState> {
  final StoryGenerationRepository _repository;

  StoryGenerationCubit(this._repository) : super(StoryGenerationInitial());

  // State güncelleme metodları
  void updateCharacterDetails(String details) {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      emit(currentState.copyWith(characterDetails: details));
    }
  }

  void updateSettingDetails(String details) {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      emit(currentState.copyWith(settingDetails: details));
    }
  }

  void updatePlotDetails(String details) {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      emit(currentState.copyWith(plotDetails: details));
    }
  }

  void updateEmotionDetails(String details) {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      emit(currentState.copyWith(emotionDetails: details));
    }
  }

  void updateLength(int length) {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      emit(currentState.copyWith(selectedLength: length));
    }
  }

  void updateCreativity(double value) {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      emit(currentState.copyWith(sliderValue: value));
    }
  }

  // Ana iş metodu
  Future<void> generateStory() async {
    if (state is StoryGenerationInitial) {
      final currentState = state as StoryGenerationInitial;
      
      // Validation
      if (!StoryGenerationValidation.hasAtLeastOneInput(
        currentState.characterDetails,
        currentState.settingDetails,
        currentState.plotDetails,
        currentState.emotionDetails,
      )) {
        emit(StoryGenerationError(StoryGenerationErrorHandler.getValidationErrorMessage()));
        return;
      }

      emit(StoryGenerationLoading());

      try {
        final params = StoryGenerationParams(
          characterDetails: currentState.characterDetails ?? '',
          settingDetails: currentState.settingDetails ?? '',
          plotDetails: currentState.plotDetails ?? '',
          emotionDetails: currentState.emotionDetails ?? '',
          selectedLength: currentState.selectedLength,
          sliderValue: currentState.sliderValue,
        );

        final story = await _repository.generateAndSaveStory(params);
        emit(StoryGenerationLoaded(story.content, story));
        
      } catch (e) {
        emit(StoryGenerationError(StoryGenerationErrorHandler.getErrorMessage(e)));
      }
    }
  }

  void resetStory() {
    emit(StoryGenerationInitial());
  }

  // Hikaye devam ettirme metodu
  Future<void> continueStory(Story existingStory, String continuationPrompt) async {
    emit(StoryGenerationLoading());

    try {
      final updatedStory = await _repository.continueStory(existingStory, continuationPrompt);
      emit(StoryGenerationLoaded(updatedStory.content, updatedStory));
    } catch (e) {
      emit(StoryGenerationError(StoryGenerationErrorHandler.getErrorMessage(e)));
    }
  }

  // Otomatik hikaye devam ettirme metodu (sadece Long hikayeler için)
  Future<void> autoContinueStory(Story existingStory) async {
    emit(StoryGenerationLoading());

    try {
      final updatedStory = await _repository.autoContinueStory(existingStory);
      emit(StoryGenerationLoaded(updatedStory.content, updatedStory));
    } catch (e) {
      emit(StoryGenerationError(StoryGenerationErrorHandler.getErrorMessage(e)));
    }
  }

}