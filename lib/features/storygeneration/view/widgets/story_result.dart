import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_state.dart';

class StoryResult extends StatelessWidget {
  final StoryGenerationLoaded state;

  const StoryResult({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF24FF00),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResultHeader(
            onClose: () {
              context.read<StoryGenerationCubit>().resetStory();
            },
          ),
          const SizedBox(height: 16),
          _StoryContent(
            content: state.generatedStory,
          ),
        ],
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _ResultHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.auto_stories,
          color: Color(0xFF24FF00),
          size: 24,
        ),
        const SizedBox(width: 12),
        const Text(
          'Generated Story',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onClose,
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _StoryContent extends StatelessWidget {
  final String content;

  const _StoryContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
