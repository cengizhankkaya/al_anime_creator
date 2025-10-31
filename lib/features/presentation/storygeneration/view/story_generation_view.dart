
import 'package:al_anime_creator/features/data/repository/story_generation_repository.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/utils/story_generation_ui_helpers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/entry_point.dart';

import 'widgets/index.dart';

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
        backgroundColor: AppColors.of(context).bacgroundblue,
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
      backgroundColor: AppColors.of(context).bacgroundblue,
      elevation: 0,
      title:  Text(
        'Hikaye Oluşturucu',
        style: TextStyle(
          color: AppColors.of(context).white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon:  Icon(Icons.more_vert, color: AppColors.of(context).limegreen),
          onPressed: () {},
        ),
      ],
    );
  }

  void _handleStateListener(BuildContext context, StoryGenerationState state) {
    if (state is StoryGenerationError) {
      StoryGenerationUIHelpers.showErrorSnackBar(context, state.message);
      // Hata durumunda form verilerini koruyarak state'i initial'a döndür
      if (state.previousState != null && context.mounted) {
        context.read<StoryGenerationCubit>().restoreState(state.previousState!);
      }
    } else if (state is StoryGenerationLoaded) {
      StoryGenerationUIHelpers.showSuccessSnackBar(context, 'Hikaye başarıyla kaydedildi!');
      if (context.mounted) {
        // Side bar görünürlüğünü korumak için EntryPoint'i hedef menü ile aç.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EntryPoint(
              initialMenuTitle: 'Geçmiş',
              initialStoryId: state.savedStory.id,
            ),
          ),
        );
      }
    }
  }

  Widget _buildBody(BuildContext context, StoryGenerationState state) {
    if (state is StoryGenerationLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.of(context).limegreen,
              ),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Hikaye oluşturuluyor...',
              style: TextStyle(
                color: AppColors.of(context).white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

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