import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:al_anime_creator/features/core/config/navigation/app_router.dart';

class StoryEmptyState extends StatelessWidget {
  const StoryEmptyState({super.key});

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
            child: const Icon(
              Icons.book_outlined,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No stories yet',
            style: TextStyle(
              color: AppColors.of(context).white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate your first story to see it here',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Story Generation sayfasına git
              context.router.push(const StoryGenerationRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context).white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Generate Story',
              style: TextStyle(
                color: AppColors.of(context).limegreen,
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

