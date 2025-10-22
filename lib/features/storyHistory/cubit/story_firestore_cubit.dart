import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storyhistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storyhistory/repository/story_repository.dart';

class StoryFirestoreCubit extends Cubit<StoryFirestoreState> {
  final StoryRepository _storyRepository;

  StoryFirestoreCubit(this._storyRepository) : super(StoryFirestoreInitial());

  /// Kullanıcının tüm hikayelerini yükle
  Future<void> loadStories() async {
    if (isClosed) return;
    emit(StoryFirestoreLoading());
    
    try {
      final stories = await _storyRepository.getStories();
      if (isClosed) return;
      emit(StoryFirestoreLoaded(stories));
    } catch (e) {
      if (isClosed) return;
      emit(StoryFirestoreError('Hikayeler yüklenirken hata oluştu: $e'));
    }
  }

  /// Belirli bir hikayeyi yükle
  Future<void> loadStory(String storyId) async {
    if (isClosed) return;
    emit(StoryFirestoreLoading());
    
    try {
      final story = await _storyRepository.getStory(storyId);
      if (isClosed) return;
      if (story != null) {
        emit(StoryFirestoreSingleLoaded(story));
      } else {
        emit(StoryFirestoreError('Hikaye bulunamadı'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(StoryFirestoreError('Hikaye yüklenirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi kaydet
  Future<void> saveStory(Story story) async {
    if (isClosed) return;
    try {
      await _storyRepository.saveStory(story);
      if (isClosed) return;
      emit(StoryFirestoreSaved(story));
    } catch (e) {
      if (isClosed) return;
      emit(StoryFirestoreError('Hikaye kaydedilirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi güncelle
  Future<void> updateStory(Story story) async {
    if (isClosed) return;
    try {
      await _storyRepository.updateStory(story);
      if (isClosed) return;
      emit(StoryFirestoreUpdated(story));
    } catch (e) {
      if (isClosed) return;
      emit(StoryFirestoreError('Hikaye güncellenirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi sil
  Future<void> deleteStory(String storyId) async {
    if (isClosed) return;
    try {
      await _storyRepository.deleteStory(storyId);
      if (isClosed) return;
      emit(StoryFirestoreDeleted(storyId));
    } catch (e) {
      if (isClosed) return;
      emit(StoryFirestoreError('Hikaye silinirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi favoriye ekle/çıkar
  Future<void> toggleFavoriteStory(String storyId, bool isFavorite) async {
    if (isClosed) return;
    try {
      // Önce mevcut hikayeyi al
      final currentState = state;
      if (currentState is StoryFirestoreLoaded) {
        final stories = currentState.stories;
        final storyIndex = stories.indexWhere((story) => story.id == storyId);

        if (storyIndex != -1) {
          final updatedStory = stories[storyIndex].copyWith(isFavorite: isFavorite);
          await _storyRepository.updateStory(updatedStory);

          // State'i güncelle
          final updatedStories = List<Story>.from(stories);
          updatedStories[storyIndex] = updatedStory;

          if (isClosed) return;
          emit(StoryFirestoreLoaded(updatedStories));
        }
      }
    } catch (e) {
      if (isClosed) return;
      emit(StoryFirestoreError('Favori durumu güncellenirken hata oluştu: $e'));
    }
  }

  /// Hikayeleri gerçek zamanlı dinle
  Stream<List<Story>> getStoriesStream() {
    return _storyRepository.getStoriesStream();
  }

  /// Durumu sıfırla
  void reset() {
    if (isClosed) return;
    emit(StoryFirestoreInitial());
  }
}
