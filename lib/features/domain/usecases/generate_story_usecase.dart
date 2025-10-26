import '../entities/story_entity.dart';
import '../repository/story_repository.dart';

class GenerateStoryUseCase {
  final StoryRepository repository;
  GenerateStoryUseCase(this.repository);

  Future<void> call(StoryEntity story) async {
    // Burada iş kuralı çalışır. Domain seviyesinde validation, örn:
    if (story.title.isEmpty) {
      throw Exception('Hikaye başlığı boş olamaz');
    }
    await repository.saveStory(story);
  }
}
