import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/storygeneration/repository/story_generation_repository.dart';
import 'package:al_anime_creator/features/storygeneration/service/ai_service.dart';

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
      if (!_isValidInput(currentState)) {
        emit(StoryGenerationError('Lütfen en az bir hikaye detayı girin'));
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
        emit(StoryGenerationError(_getErrorMessage(e)));
      }
    }
  }

  void resetStory() {
    emit(StoryGenerationInitial());
  }

  bool _isValidInput(StoryGenerationInitial state) {
    return (state.characterDetails?.isNotEmpty ?? false) ||
           (state.settingDetails?.isNotEmpty ?? false) ||
           (state.plotDetails?.isNotEmpty ?? false) ||
           (state.emotionDetails?.isNotEmpty ?? false);
  }

  String _getErrorMessage(Object error) {
    String errorMessage = 'Hikaye oluşturulurken hata oluştu: ';
    if (error.toString().contains('timeout')) {
      errorMessage += 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
    } else if (error.toString().contains('network')) {
      errorMessage += 'İnternet bağlantınızı kontrol edin.';
    } else {
      errorMessage += error.toString();
    }
    return errorMessage;
  }
}