import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/date_formatter.dart';

/// Reader sayfasında story bilgilerini gösteren header widget
class ReaderHeaderWidget extends StatelessWidget {
  final Story story;
  final String locale;

  const ReaderHeaderWidget({
    super.key,
    required this.story,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
            _getTranslatedComplexity(story.settings.complexity),
            style: TextStyle(
              color: _complexityColor(story.settings.complexity),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          DateFormatter.relativeOrDate(story.createdAt, locale: locale),
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getTranslatedComplexity(String complexity) {
    if (locale.toLowerCase() == 'tr') {
      switch (complexity.toLowerCase()) {
        case 'creative':
          return 'Yaratıcı';
        case 'complex':
          return 'Karmaşık';
        case 'standard':
          return 'Standart';
        default:
          return complexity;
      }
    }
    return complexity;
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

