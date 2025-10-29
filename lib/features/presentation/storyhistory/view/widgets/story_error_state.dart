import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/cubit/story_firestore_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryErrorState extends StatelessWidget {
  final String errorMessage;

  const StoryErrorState({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Hata: $errorMessage',
            style: TextStyle(color: AppColors.of(context).white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<StoryFirestoreCubit>().loadStories(),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}

