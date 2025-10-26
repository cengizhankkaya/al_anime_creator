class StoryHistoryEntryEntity {
  final String storyId;
  final DateTime lastReadAt;
  final bool isFavorite;

  const StoryHistoryEntryEntity({
    required this.storyId,
    required this.lastReadAt,
    this.isFavorite = false,
  });
}
