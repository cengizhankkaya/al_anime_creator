import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';

class LoadingButton extends StatelessWidget {
  final StoryGenerationState state;

  const LoadingButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isLoading = state is StoryGenerationLoading;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onPressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? Colors.grey.shade700
              : const Color(0xFF24FF00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : const Text(
                'Generate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  VoidCallback? _onPressed(BuildContext context) {
    if (state is StoryGenerationLoading) return null;

    return () {
      context.read<StoryGenerationCubit>().generateStory();
    };
  }
}
