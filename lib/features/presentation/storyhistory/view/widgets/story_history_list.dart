import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/story_card.dart';
import 'package:flutter/material.dart';

class StoryHistoryList extends StatelessWidget {
  final List<Story> stories;
  final ValueChanged<Story> onStoryTap;
  final ValueChanged<Story> onToggleFavorite;
  final ValueChanged<Story>? onDeleteStory;

  const StoryHistoryList({
    super.key,
    required this.stories,
    required this.onStoryTap,
    required this.onToggleFavorite,
    this.onDeleteStory,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryCard(
          story: story,
          onTap: () => onStoryTap(story),
          onToggleFavorite: () => onToggleFavorite(story),
          onDeleteStory: onDeleteStory != null ? () => onDeleteStory!(story) : null,
          locale: 'tr',
        );
      },
    );
  }
}

