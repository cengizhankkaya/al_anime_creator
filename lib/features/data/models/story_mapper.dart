import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/domain/entities/story_entity.dart';

// Data - Domain Mapper
extension StoryMapper on Story {
  StoryEntity toEntity() {
    return StoryEntity(
      id: id,
      title: title,
      chapters: chapters.map((c) => c.toEntity()).toList(),
      createdAt: createdAt,
      isFavorite: isFavorite,
    );
  }
}

extension ChapterMapper on Chapter {
  ChapterEntity toEntity() {
    return ChapterEntity(
      id: id,
      title: title,
      content: content,
      chapterNumber: chapterNumber,
    );
  }
}

// Domain - Data Mapper
extension StoryEntityMapper on StoryEntity {
  Story toModel({
    List<Chapter>? allChapterModels,
    // Gerekirse ek domain->data mapping parametreleri
  }) {
    return Story(
      id: id,
      title: title,
      chapters: chapters.map((c) => Chapter(
        id: c.id,
        title: c.title,
        content: c.content,
        chapterNumber: c.chapterNumber,
      )).toList(),
      createdAt: createdAt,
      settings: StorySettings( // Placeholder, mapping ihtiyacına göre genişletilir
        length: '',
        complexity: '',
        characterDetails: '',
        settingEnvironment: '',
        plotStructure: '',
        emotionsTone: '',
      ),
    );
  }
}
