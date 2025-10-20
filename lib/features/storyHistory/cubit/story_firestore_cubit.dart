import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storyHistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/product/service/firestore_service.dart';

class StoryFirestoreCubit extends Cubit<StoryFirestoreState> {
  final FirestoreService _firestoreService;

  StoryFirestoreCubit(this._firestoreService) : super(StoryFirestoreInitial());

  /// Kullanıcının tüm hikayelerini yükle
  Future<void> loadStories() async {
    emit(StoryFirestoreLoading());
    
    try {
      final stories = await _firestoreService.getStories();
      emit(StoryFirestoreLoaded(stories));
    } catch (e) {
      emit(StoryFirestoreError('Hikayeler yüklenirken hata oluştu: $e'));
    }
  }

  /// Belirli bir hikayeyi yükle
  Future<void> loadStory(String storyId) async {
    emit(StoryFirestoreLoading());
    
    try {
      final story = await _firestoreService.getStory(storyId);
      if (story != null) {
        emit(StoryFirestoreSingleLoaded(story));
      } else {
        emit(StoryFirestoreError('Hikaye bulunamadı'));
      }
    } catch (e) {
      emit(StoryFirestoreError('Hikaye yüklenirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi kaydet
  Future<void> saveStory(Story story) async {
    try {
      await _firestoreService.saveStory(story);
      emit(StoryFirestoreSaved(story));
    } catch (e) {
      emit(StoryFirestoreError('Hikaye kaydedilirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi güncelle
  Future<void> updateStory(Story story) async {
    try {
      await _firestoreService.updateStory(story);
      emit(StoryFirestoreUpdated(story));
    } catch (e) {
      emit(StoryFirestoreError('Hikaye güncellenirken hata oluştu: $e'));
    }
  }

  /// Hikayeyi sil
  Future<void> deleteStory(String storyId) async {
    try {
      await _firestoreService.deleteStory(storyId);
      emit(StoryFirestoreDeleted(storyId));
    } catch (e) {
      emit(StoryFirestoreError('Hikaye silinirken hata oluştu: $e'));
    }
  }

  /// Hikayeleri gerçek zamanlı dinle
  Stream<List<Story>> getStoriesStream() {
    return _firestoreService.getStoriesStream();
  }

  /// Durumu sıfırla
  void reset() {
    emit(StoryFirestoreInitial());
  }
}
