import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/features/core/service_locator.dart';
import 'package:auto_route/auto_route.dart';
// utils now used inside ReaderPage/StoryCard
import 'package:al_anime_creator/features/presentation/storyhistory/view/reader_page.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/favorites_empty_state.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/favorites_list.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';

@RoutePage()
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late StoryFirestoreCubit _storyCubit;
  // Removed: per-reader state is handled inside _StoryReaderView

  @override
  void initState() {
    super.initState();
    _storyCubit = getIt<StoryFirestoreCubit>();
    _storyCubit.loadStories();
  }

  void _toggleFavorite(Story story) {
    _storyCubit.toggleFavoriteStory(story.id, !story.isFavorite);
  }

  void _openReader(Story story) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<StoryGenerationCubit>(),
          child: ReaderPage(
            story: story,
            onToggleFavorite: _toggleFavorite,
            locale: 'tr',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).bacgroundblue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Text(
          'Favori Hikayeler',
          style: TextStyle(
            color: AppColors.of(context).white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
      ),
      body: BlocBuilder<StoryFirestoreCubit, StoryFirestoreState>(
        bloc: _storyCubit,
        builder: (context, state) {
          if (state is StoryFirestoreLoading) {
            return  Center(
              child: CircularProgressIndicator(
                color: AppColors.of(context).limegreen,
              ),
            );
          }

          if (state is StoryFirestoreError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hata: ${state.message}',
                    style:  TextStyle(color: AppColors.of(context).white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _storyCubit.loadStories(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (state is StoryFirestoreLoaded) {
            final favoriteStories = state.stories.where((story) => story.isFavorite).toList();
            if (favoriteStories.isEmpty) {
              return FavoritesEmptyState(onViewAll: () => Navigator.of(context).pop());
            }
            return FavoritesList(
              stories: favoriteStories,
              onOpenStory: _openReader,
              onToggleFavorite: _toggleFavorite,
            );
          }
          return  Center(
            child: CircularProgressIndicator(
              color: AppColors.of(context).limegreen,
            ),
          );
        },
      ),
    );
  }

  

  
}
 
