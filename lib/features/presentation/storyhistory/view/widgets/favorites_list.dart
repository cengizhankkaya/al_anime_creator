import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/story_card.dart';

class FavoritesList extends StatelessWidget {
  final List<Story> stories;
  final void Function(Story) onOpenStory;
  final void Function(Story) onToggleFavorite;

  const FavoritesList({
    super.key,
    required this.stories,
    required this.onOpenStory,
    required this.onToggleFavorite,
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
          onTap: () => onOpenStory(story),
          onToggleFavorite: () => onToggleFavorite(story),
          locale: 'tr',
          highlightFavorite: true,
        );
      },
    );
  }
}
