import 'package:flutter/material.dart';

/// Story'nin alt kısmındaki aksiyon butonlarını gösteren widget
class StoryActionsWidget extends StatelessWidget {
  final String length;
  final String formattedDate;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onContinueStory;
  final VoidCallback? onAutoContinueStory;
  final String locale;

  const StoryActionsWidget({
    super.key,
    required this.length,
    required this.formattedDate,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onContinueStory,
    this.onAutoContinueStory,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF24FF00).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            length,
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
        IconButton(
          onPressed: onToggleFavorite,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? const Color(0xFF24FF00) : Colors.grey,
            size: 20,
          ),
        ),
        if (_shouldShowAutoContinueButton())
          IconButton(
            onPressed: onAutoContinueStory,
            icon: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF24FF00),
              size: 20,
            ),
            tooltip: locale == 'tr' ? 'Otomatik Devam Et' : 'Auto Continue',
          ),
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
    );
  }

  bool _shouldShowAutoContinueButton() {
    return length.toLowerCase() == 'long' && onAutoContinueStory != null;
  }
}
