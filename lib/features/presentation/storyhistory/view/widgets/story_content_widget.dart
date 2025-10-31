import 'package:flutter/material.dart';

/// Story'nin bölüm sayısı ve içerik önizlemesini gösteren widget
class StoryContentWidget extends StatelessWidget {
  final int chapterCount;
  final String contentPreview;
  final String locale;
  final int? pageCount;

  const StoryContentWidget({
    super.key,
    required this.chapterCount,
    required this.contentPreview,
    this.locale = 'en',
    this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.book_outlined,
          color: Colors.grey.shade400,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          _getMetaText(),
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
              contentPreview,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getMetaText() {
    final isTurkish = locale == 'tr';
    final chapterText = chapterCount == 1
        ? (isTurkish ? 'Bölüm' : 'Chapter')
        : (isTurkish ? 'Bölüm' : 'Chapters');

    final chapterPart = '$chapterCount $chapterText';

    if (pageCount != null) {
      final pageText = pageCount == 1
          ? (isTurkish ? 'sayfa' : 'page')
          : (isTurkish ? 'sayfa' : 'pages');
      return '$chapterPart • $pageCount $pageText';
    }

    return chapterPart;
  }
}
