import '../repository/story_history_repository.dart';

class MarkFavoriteUseCase {
  final StoryHistoryRepository repository;
  MarkFavoriteUseCase(this.repository);

  Future<void> call(String userId, String storyId, bool isFavorite) async {
    await repository.markFavorite(userId, storyId, isFavorite);
  }
}
