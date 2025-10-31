import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/widgets/input_section.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/utils/random_story_inputs.dart';

class InputSections extends StatelessWidget {
  final StoryGenerationInitial state;

  const InputSections({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputSection(
          title: 'Karakter Detayları',
          subtitle: 'İsim, yaş, kişilik, görünüm.',
          value: state.characterDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateCharacterDetails(value);
          },
          onRandom: () {
            final r = RandomStoryInputsGenerator.generate();
            context.read<StoryGenerationCubit>().updateCharacterDetails(r.characterDetails);
          },
        ),
        const SizedBox(height: 16),
        InputSection(
          title: 'Mekan ve Çevre',
          subtitle: 'Konum, atmosfer.',
          value: state.settingDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateSettingDetails(value);
          },
          onRandom: () {
            final r = RandomStoryInputsGenerator.generate();
            context.read<StoryGenerationCubit>().updateSettingDetails(r.settingDetails);
          },
        ),
        const SizedBox(height: 16),
        InputSection(
          title: 'Olay Örgüsü',
          subtitle: 'Başlangıç, gelişim, çatışma, çözüm.',
          value: state.plotDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updatePlotDetails(value);
          },
          onRandom: () {
            final r = RandomStoryInputsGenerator.generate();
            context.read<StoryGenerationCubit>().updatePlotDetails(r.plotDetails);
          },
        ),
        const SizedBox(height: 16),
        InputSection(
          title: 'Duygular ve Ton',
          subtitle: "Karakterin hisleri, hikayenin genel ruh hali.",
          value: state.emotionDetails ?? '',
          onChanged: (value) {
            context.read<StoryGenerationCubit>().updateEmotionDetails(value);
          },
          onRandom: () {
            final r = RandomStoryInputsGenerator.generate();
            context.read<StoryGenerationCubit>().updateEmotionDetails(r.emotionDetails);
          },
        ),
      ],
    );
  }
}
