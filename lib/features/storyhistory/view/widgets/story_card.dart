import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storyhistory/utils/date_formatter.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onContinueStory;
  final VoidCallback? onAutoContinueStory;
  final String locale;
  final bool highlightFavorite;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    required this.onToggleFavorite,
    this.onContinueStory,
    this.onAutoContinueStory,
    this.locale = 'en',
    this.highlightFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormatter.relativeOrDate(story.createdAt, locale: locale);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlightFavorite ? const Color(0xFF24FF00).withOpacity(0.3) : Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (story.mainImageUrl != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF24FF00), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x6624FF00),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        story.mainImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (story.mainImageUrl != null) const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _complexityColor(story.settings.complexity).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _complexityColor(story.settings.complexity),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      story.settings.complexity,
                      style: TextStyle(
                        color: _complexityColor(story.settings.complexity),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.book_outlined,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${story.chapters.length} ${story.chapters.length == 1 ? (locale == 'tr' ? 'Bölüm' : 'Chapter') : (locale == 'tr' ? 'Bölüm' : 'Chapters')}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        story.chapters.first.content.length > 80
                            ? '${story.chapters.first.content.substring(0, 80)}...'
                            : story.chapters.first.content,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      story.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: story.isFavorite ? const Color(0xFF24FF00) : Colors.grey,
                      size: 20,
                    ),
                  ),
                  // Long hikayeler için otomatik devam ettirme butonu
                  if (story.settings.length.toLowerCase() == 'long' && onAutoContinueStory != null)
                    IconButton(
                      onPressed: onAutoContinueStory,
                      icon: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF24FF00),
                        size: 20,
                      ),
                      tooltip: locale == 'tr' ? 'Otomatik Devam Et' : 'Auto Continue',
                    ),
                  // Manuel devam ettirme butonu
                  if (onContinueStory != null)
                    IconButton(
                      onPressed: onContinueStory,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF24FF00),
                        size: 20,
                      ),
                      tooltip: locale == 'tr' ? 'Hikayeyi Devam Ettir' : 'Continue Story',
                    ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF24FF00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      story.settings.length,
                      style: const TextStyle(
                        color: Color(0xFF24FF00),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _complexityColor(String complexity) {
    switch (complexity.toLowerCase()) {
      case 'creative':
        return const Color(0xFF24FF00);
      case 'complex':
        return Colors.orange;
      case 'standard':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}


