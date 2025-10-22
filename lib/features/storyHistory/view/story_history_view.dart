
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storyhistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/storyhistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/product/service/service_locator.dart';
import 'package:al_anime_creator/product/init/navigation/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_route/annotations.dart';
// utils used internally by ReaderPage/StoryCard
import 'package:al_anime_creator/features/storyhistory/view/reader_page.dart';
import 'package:al_anime_creator/features/storyhistory/view/widgets/story_card.dart';
import 'package:al_anime_creator/features/storygeneration/cubit/story_generation_cubit.dart';

class StoryHistoryView extends StatefulWidget {
  final String? initialStoryId; // Otomatik seçilecek hikaye ID'si

  const StoryHistoryView({
    super.key,
    this.initialStoryId,
  });

  @override
  State<StoryHistoryView> createState() => _StoryHistoryViewState();
}

@RoutePage(
  name: 'StoryHistoryRoute',
)
class StoryHistoryViewWrapper extends StatelessWidget {
  final String? storyId; // Otomatik seçilecek hikaye ID'si

  const StoryHistoryViewWrapper({
    super.key,
    this.storyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StoryFirestoreCubit>(),
      child: StoryHistoryView(initialStoryId: storyId),
    );
  }
}

class _StoryHistoryViewState extends State<StoryHistoryView> {
  bool _showOnlyFavorites = false;
  bool _initialNavigated = false;

  @override
  void initState() {
    super.initState();
    // Firebase'den hikayeleri yükle
    context.read<StoryFirestoreCubit>().loadStories();

    // Navigasyon, state yüklendiğinde yapılacak (BlocListener içinde)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sayfa her açıldığında hikayeleri yeniden yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StoryFirestoreCubit>().loadStories();
      }
    });
  }

  void _openReader(Story story) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<StoryGenerationCubit>(),
          child: ReaderPage(
            story: story,
            onToggleFavorite: (s) => context.read<StoryFirestoreCubit>().toggleFavoriteStory(s.id, !s.isFavorite),
            locale: 'en',
          ),
        ),
      ),
    );
  }

  void _toggleFavorite(Story story) {
    context.read<StoryFirestoreCubit>().toggleFavoriteStory(story.id, !story.isFavorite);
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Filtrele',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tüm Hikayeler', style: TextStyle(color: Colors.white)),
                leading: Radio<bool>(
                  value: false,
                  groupValue: _showOnlyFavorites,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyFavorites = value!;
                    });
                    Navigator.of(context).pop();
                  },
                  activeColor: const Color(0xFF24FF00),
                ),
              ),
              ListTile(
                title: const Text('Sadece Favoriler', style: TextStyle(color: Colors.white)),
                leading: Radio<bool>(
                  value: true,
                  groupValue: _showOnlyFavorites,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyFavorites = value!;
                    });
                    Navigator.of(context).pop();
                  },
                  activeColor: const Color(0xFF24FF00),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Story> _getFilteredStories(List<Story> stories) {
    if (!_showOnlyFavorites) {
      return stories;
    }
    return stories.where((story) => story.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Story History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: BlocListener<StoryFirestoreCubit, StoryFirestoreState>(
        listener: (context, state) {
          if (state is StoryFirestoreDeleted) {
            // Hikaye silindiğinde hikayeler listesini yeniden yükle
            context.read<StoryFirestoreCubit>().loadStories();
          }
          if (state is StoryFirestoreSaved) {
            // Hikaye kaydedildiğinde listeyi tazele
            context.read<StoryFirestoreCubit>().loadStories();
          }
          if (state is StoryFirestoreUpdated) {
            // Hikaye güncellendiğinde listeyi tazele
            context.read<StoryFirestoreCubit>().loadStories();
          }
          if (state is StoryFirestoreLoaded && !_initialNavigated && widget.initialStoryId != null) {
            final target = state.stories.where((s) => s.id == widget.initialStoryId).firstOrNull;
            if (target != null) {
              _initialNavigated = true;
              _openReader(target);
            }
          }
        },
        child: BlocBuilder<StoryFirestoreCubit, StoryFirestoreState>(
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
                    onPressed: () => context.read<StoryFirestoreCubit>().loadStories(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (state is StoryFirestoreLoaded) {
            final stories = state.stories;
            final filteredStories = _getFilteredStories(stories);

            if (stories.isEmpty) {
              return _buildEmptyState();
            }

            if (filteredStories.isEmpty && _showOnlyFavorites) {
              return _buildEmptyFavoritesState();
            }

            return _buildStoriesList(filteredStories);
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF24FF00),
            ),
          );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.book_outlined,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No stories yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate your first story to see it here',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Story Generation sayfasına git
              context.router.push(const StoryGenerationRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF24FF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Generate Story',
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
            'No favorite stories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mark stories as favorite to see them here',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showOnlyFavorites = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF24FF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Show All Stories',
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

  Widget _buildStoriesList(List<Story> stories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(story);
      },
    );
  }

  Widget _buildStoryCard(Story story) {
    return StoryCard(
      story: story,
      onTap: () => _openReader(story),
      onToggleFavorite: () => _toggleFavorite(story),
      locale: 'en',
    );
  }
  



  

  // Parça hesaplama ReaderPage'e taşındı

}