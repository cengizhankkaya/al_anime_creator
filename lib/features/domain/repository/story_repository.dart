import '../entities/story_entity.dart';

abstract class StoryRepository {
  Future<List<StoryEntity>> getStories();
  Future<StoryEntity?> getStory(String storyId);
  Future<void> saveStory(StoryEntity story);
  Future<void> updateStory(StoryEntity story);
  Future<void> deleteStory(String storyId);
  Stream<List<StoryEntity>> getStoriesStream();
}
