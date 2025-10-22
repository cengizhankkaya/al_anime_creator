import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/product/service/firestore_service.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();
  Future<Story?> getStory(String storyId);
  Future<void> saveStory(Story story);
  Future<void> updateStory(Story story);
  Future<void> deleteStory(String storyId);
  Stream<List<Story>> getStoriesStream();
}

class StoryRepositoryImpl implements StoryRepository {
  final FirestoreService _firestoreService;

  StoryRepositoryImpl(this._firestoreService);

  @override
  Future<List<Story>> getStories() => _firestoreService.getStories();

  @override
  Future<Story?> getStory(String storyId) => _firestoreService.getStory(storyId);

  @override
  Future<void> saveStory(Story story) => _firestoreService.saveStory(story);

  @override
  Future<void> updateStory(Story story) => _firestoreService.updateStory(story);

  @override
  Future<void> deleteStory(String storyId) => _firestoreService.deleteStory(storyId);

  @override
  Stream<List<Story>> getStoriesStream() => _firestoreService.getStoriesStream();
}


