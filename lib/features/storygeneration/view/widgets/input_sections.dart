import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/storygeneration/view/widgets/input_section.dart';

class InputSections extends StatelessWidget {
  final StoryGenerationInitial state;

  const InputSections({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputSection(
          title: 'character details',
          subtitle: 'Name, age, personality, appearance.',
          value: state.characterDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateCharacterDetails(value);
          },
        ),
        const SizedBox(height: 16),
        InputSection(
          title: 'setting and environment',
          subtitle: 'Location, atmosphere.',
          value: state.settingDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateSettingDetails(value);
          },
        ),
        const SizedBox(height: 16),
        InputSection(
          title: 'plot structure',
          subtitle: 'Beginning, development, conflict, resolution.',
          value: state.plotDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updatePlotDetails(value);
          },
        ),
        const SizedBox(height: 16),
        InputSection(
          title: 'emotions and tone',
          subtitle: "Character's feeling, overall mood of the story.",
          value: state.emotionDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateEmotionDetails(value);
          },
        ),
      ],
    );
  }
}
