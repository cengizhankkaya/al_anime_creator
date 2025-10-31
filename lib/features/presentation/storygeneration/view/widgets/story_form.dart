import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/widgets/length_selector.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/widgets/creativity_slider.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/widgets/input_sections.dart';

class StoryForm extends StatelessWidget {
  final StoryGenerationState state;

  const StoryForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    StoryGenerationInitial initialState;
    
    if (state is StoryGenerationInitial) {
      initialState = state as StoryGenerationInitial;
    } else if (state is StoryGenerationError && (state as StoryGenerationError).previousState != null) {
      initialState = (state as StoryGenerationError).previousState!;
    } else {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LengthSelector(
          selectedLength: initialState.selectedLength,
          onLengthSelected: (length) {
            context.read<StoryGenerationCubit>().updateLength(length);
          },
        ),
        const SizedBox(height: 30),
        InputSections(state: initialState),
        const SizedBox(height: 40),
        CreativitySlider(
          value: initialState.sliderValue,
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateCreativity(value);
          },
        ),
      ],
    );
  }
}
