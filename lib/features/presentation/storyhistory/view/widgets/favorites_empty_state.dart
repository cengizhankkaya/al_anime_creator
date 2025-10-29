import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';

class FavoritesEmptyState extends StatelessWidget {
  final VoidCallback onViewAll;

  const FavoritesEmptyState({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.favorite_border,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorite stories',
            style: TextStyle(
              color: AppColors.of(context).white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mark stories as favorite to see them here',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onViewAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context).limegreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Show All Stories',
              style: TextStyle(
                color: AppColors.of(context).blackd,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
