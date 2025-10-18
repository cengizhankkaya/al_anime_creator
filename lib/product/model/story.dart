class Chapter {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final int chapterNumber;

  const Chapter({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.chapterNumber,
  });

  Chapter copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    int? chapterNumber,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      chapterNumber: chapterNumber ?? this.chapterNumber,
    );
  }
}

class Story {
  final String id;
  final String title;
  final List<Chapter> chapters;
  final DateTime createdAt;
  final String? coverImageUrl;
  final StorySettings settings;

  const Story({
    required this.id,
    required this.title,
    required this.chapters,
    required this.createdAt,
    this.coverImageUrl,
    required this.settings,
  });

  // Getter for total content (combining all chapters)
  String get content => chapters.map((chapter) => chapter.content).join('\n\n');

  // Getter for main image (first chapter's image or cover image)
  String? get mainImageUrl => chapters.isNotEmpty ? chapters.first.imageUrl : coverImageUrl;

  Story copyWith({
    String? id,
    String? title,
    List<Chapter>? chapters,
    DateTime? createdAt,
    String? coverImageUrl,
    StorySettings? settings,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      chapters: chapters ?? this.chapters,
      createdAt: createdAt ?? this.createdAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      settings: settings ?? this.settings,
    );
  }
}

class StorySettings {
  final String length; // Short, Mid, Long
  final String complexity; // Standard, Complex, Creative
  final String characterDetails;
  final String settingEnvironment;
  final String plotStructure;
  final String emotionsTone;

  const StorySettings({
    required this.length,
    required this.complexity,
    required this.characterDetails,
    required this.settingEnvironment,
    required this.plotStructure,
    required this.emotionsTone,
  });

  StorySettings copyWith({
    String? length,
    String? complexity,
    String? characterDetails,
    String? settingEnvironment,
    String? plotStructure,
    String? emotionsTone,
  }) {
    return StorySettings(
      length: length ?? this.length,
      complexity: complexity ?? this.complexity,
      characterDetails: characterDetails ?? this.characterDetails,
      settingEnvironment: settingEnvironment ?? this.settingEnvironment,
      plotStructure: plotStructure ?? this.plotStructure,
      emotionsTone: emotionsTone ?? this.emotionsTone,
    );
  }
}
