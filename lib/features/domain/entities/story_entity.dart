// Story domain entity (yalnızca iş mantığıyla ilgili alanlar)
class StoryEntity {
  final String id;
  final String title;
  final List<ChapterEntity> chapters;
  final DateTime createdAt;
  final bool isFavorite;

  const StoryEntity({
    required this.id,
    required this.title,
    required this.chapters,
    required this.createdAt,
    this.isFavorite = false,
  });
}

class ChapterEntity {
  final String id;
  final String title;
  final String content;
  final int chapterNumber;

  const ChapterEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.chapterNumber,
  });
}
