
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/storygeneration/repository/story_generation_repository.dart';
import 'package:al_anime_creator/features/storygeneration/view/widgets/story_form.dart';
import 'package:al_anime_creator/features/storygeneration/view/widgets/loading_button.dart';
import 'package:al_anime_creator/features/storygeneration/view/utils/ui_helpers.dart';
import 'package:al_anime_creator/features/storygeneration/view/utils/app_colors.dart';
import 'package:al_anime_creator/product/init/navigation/app_router.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage(
  name: 'StoryGenerationRoute',
)
class StoryGenerationView extends StatelessWidget {
  const StoryGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryGenerationCubit>(
      create: (context) => StoryGenerationCubit(
        GetIt.I<StoryGenerationRepository>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: BlocConsumer<StoryGenerationCubit, StoryGenerationState>(
          listener: (context, state) => _handleStateListener(context, state),
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Result Image',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  void _handleStateListener(BuildContext context, StoryGenerationState state) {
    if (state is StoryGenerationError) {
      UIHelpers.showErrorSnackBar(context, state.message);
    } else if (state is StoryGenerationLoaded) {
      UIHelpers.showSuccessSnackBar(context, 'Hikaye başarıyla kaydedildi!');
      // Hikaye oluşturulduktan hemen sonra Story History sayfasına yönlendir
      // Oluşturulan hikayenin detayına gitmek için story ID'sini geç
      if (context.mounted) {
        context.router.replace(StoryHistoryRoute(storyId: state.savedStory.id));
      }
    }
  }

  Widget _buildBody(BuildContext context, StoryGenerationState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            StoryForm(state: state),
            const SizedBox(height: 40),
            LoadingButton(state: state),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}