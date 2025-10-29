import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/core/index.dart';

/// Reader sayfasında sayfa navigasyon kontrollerini gösteren widget
class ReaderNavigationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int currentContentLength;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String locale;

  const ReaderNavigationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.currentContentLength,
    required this.isFirst,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: isFirst ? null : onPrevious,
            icon: Icon(
              Icons.arrow_back_ios,
              color: isFirst ? Colors.grey : Colors.white,
            ),
          ),
          Column(
            children: [
              Text(
                locale == 'tr' 
                    ? 'Sayfa  ${currentPage + 1} / $totalPages' 
                    : 'Page ${currentPage + 1} of $totalPages',
                style: TextStyle(
                  color: AppColors.of(context).white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$currentContentLength ${locale == 'tr' ? 'karakter' : 'characters'}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: isLast ? null : onNext,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: isLast ? AppColors.of(context).limegreen : AppColors.of(context).white,
            ),
          ),
        ],
      ),
    );
  }
}

