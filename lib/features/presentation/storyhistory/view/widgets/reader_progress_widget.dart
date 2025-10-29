import 'package:flutter/material.dart';

/// Reader sayfasında okuma ilerlemesini gösteren widget
class ReaderProgressWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final String locale;

  const ReaderProgressWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentPage + 1) / totalPages;
    final progressPercentage = (progress * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale == 'tr' ? 'Okuma İlerlemesi' : 'Reading Progress',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$progressPercentage%',
                style: const TextStyle(
                  color: Color(0xFF24FF00),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade800,
            minHeight: 8,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF24FF00),
            ),
          ),
        ],
      ),
    );
  }
}

