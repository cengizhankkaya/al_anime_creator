import 'package:al_anime_creator/features/data/models/story.dart';


abstract class StoryFirestoreState {
  const StoryFirestoreState();
}

/// Başlangıç durumu
class StoryFirestoreInitial extends StoryFirestoreState {}

/// Yükleme durumu
class StoryFirestoreLoading extends StoryFirestoreState {}

/// Hikayeler başarıyla yüklendi
class StoryFirestoreLoaded extends StoryFirestoreState {
  final List<Story> stories;

  const StoryFirestoreLoaded(this.stories);
}

/// Tek bir hikaye başarıyla yüklendi
class StoryFirestoreSingleLoaded extends StoryFirestoreState {
  final Story story;

  const StoryFirestoreSingleLoaded(this.story);
}

/// Hikaye başarıyla kaydedildi
class StoryFirestoreSaved extends StoryFirestoreState {
  final Story story;

  const StoryFirestoreSaved(this.story);
}

/// Hikaye başarıyla güncellendi
class StoryFirestoreUpdated extends StoryFirestoreState {
  final Story story;

  const StoryFirestoreUpdated(this.story);
}

/// Hikaye başarıyla silindi
class StoryFirestoreDeleted extends StoryFirestoreState {
  final String storyId;

  const StoryFirestoreDeleted(this.storyId);
}

/// Hata durumu
class StoryFirestoreError extends StoryFirestoreState {
  final String message;

  const StoryFirestoreError(this.message);
}
