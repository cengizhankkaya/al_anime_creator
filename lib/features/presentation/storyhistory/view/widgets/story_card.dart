import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/date_formatter.dart';
import 'story_image_widget.dart';
import 'story_header_widget.dart';
import 'story_content_widget.dart';
import 'story_actions_widget.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onContinueStory;
  final VoidCallback? onAutoContinueStory;
  final VoidCallback? onDeleteStory;
  final String locale;
  final bool highlightFavorite;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    required this.onToggleFavorite,
    this.onContinueStory,
    this.onAutoContinueStory,
    this.onDeleteStory,
    this.locale = 'en',
    this.highlightFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormatter.relativeOrDate(story.createdAt, locale: locale);
    final contentPreview = _getContentPreview();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.of(context).limegreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlightFavorite ? AppColors.of(context).limegreen.withValues(alpha: 0.3) : AppColors.of(context).greyColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (story.mainImageUrl != null) ...[
                StoryImageWidget(imageUrl: story.mainImageUrl!),
                const SizedBox(height: 12),
              ],
              StoryHeaderWidget(
                title: story.title,
                complexity: story.settings.complexity,
                locale: locale,
              ),
              const SizedBox(height: 8),
              StoryContentWidget(
                chapterCount: story.chapters.length,
                contentPreview: contentPreview,
                locale: locale,
              ),
              const SizedBox(height: 12),
              StoryActionsWidget(
                length: story.settings.length,
                formattedDate: formattedDate,
                isFavorite: story.isFavorite,
                onToggleFavorite: onToggleFavorite,
                onContinueStory: onContinueStory,
                onAutoContinueStory: onAutoContinueStory,
                onDeleteStory: onDeleteStory,
                locale: locale,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// İçerik önizlemesini hazırlar
  String _getContentPreview() {
    final content = _cleanMarkdownCharacters(story.chapters.first.content);
    return content.length > 80 ? '${content.substring(0, 80)}...' : content;
  }

  /// Markdown karakterlerini (* ve #) temizler
  String _cleanMarkdownCharacters(String content) {
    String text = content;
    // * karakterlerini kaldır (markdown bold ve list işaretleri için)
    text = text.replaceAll(RegExp(r'\*+'), '');
    // # karakterlerini kaldır (markdown başlık işaretleri için)
    text = text.replaceAll(RegExp(r'#+\s*'), '');
    return text;
  }

}


