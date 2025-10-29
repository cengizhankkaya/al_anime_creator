import 'package:flutter/material.dart';

/// Story'nin başlık ve complexity bilgilerini gösteren widget
class StoryHeaderWidget extends StatelessWidget {
  final String title;
  final String complexity;

  const StoryHeaderWidget({
    super.key,
    required this.title,
    required this.complexity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
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
            color: _complexityColor(complexity).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _complexityColor(complexity),
              width: 1,
            ),
          ),
          child: Text(
            complexity,
            style: TextStyle(
              color: _complexityColor(complexity),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
