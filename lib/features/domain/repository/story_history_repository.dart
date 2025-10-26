import '../entities/story_history_entry_entity.dart';

abstract class StoryHistoryRepository {
  Future<List<StoryHistoryEntryEntity>> getUserHistory(String userId);
  Future<void> addHistoryEntry(String userId, StoryHistoryEntryEntity entry);
  Future<void> updateHistoryEntry(String userId, StoryHistoryEntryEntity entry);
  Future<void> removeHistoryEntry(String userId, String storyId);
  Future<void> markFavorite(String userId, String storyId, bool isFavorite);
}
