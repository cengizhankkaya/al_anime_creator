import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
              : AppColors.of(context).limegreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 28,
                height: 28,
                child: Lottie.asset(
                  'assets/lottie/Parchment.lottie',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              )
            : const Text(
                'Oluştur',
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
