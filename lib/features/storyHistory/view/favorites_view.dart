import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storyhistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/storyhistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/product/service/service_locator.dart';
import 'package:auto_route/auto_route.dart';
// utils now used inside ReaderPage/StoryCard
import 'package:al_anime_creator/features/storyhistory/view/reader_page.dart';
import 'package:al_anime_creator/features/storyhistory/view/widgets/story_card.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Favori Hikayeler',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
      ),
      body: BlocBuilder<StoryFirestoreCubit, StoryFirestoreState>(
        bloc: _storyCubit,
        builder: (context, state) {
          if (state is StoryFirestoreLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF24FF00),
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
                    style: const TextStyle(color: Colors.white),
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
              return _buildEmptyFavoritesState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: favoriteStories.length,
              itemBuilder: (context, index) {
                final story = favoriteStories[index];
                return _buildFavoriteStoryCard(story);
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF24FF00),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyFavoritesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Henüz favori hikaye yok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hikayeleri favoriye ekleyerek burada görüntüleyin',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF24FF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Tüm Hikayeleri Görüntüle',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteStoryCard(Story story) {
    return StoryCard(
      story: story,
      onTap: () {
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
      },
      onToggleFavorite: () => _toggleFavorite(story),
      locale: 'tr',
      highlightFavorite: true,
    );
  }

  
}
 
