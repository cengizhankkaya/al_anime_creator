
import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/features/core/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/reader_page.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/story_filter_dialog.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/story_empty_state.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/story_error_state.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/story_history_list.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/favorites_empty_state.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';

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
    StoryFilterDialog.show(
      context,
      showOnlyFavorites: _showOnlyFavorites,
      onFilterChanged: (value) {
        setState(() {
          _showOnlyFavorites = value;
        });
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
      backgroundColor: AppColors.of(context).bacgroundblue,
      appBar: AppBar(
        backgroundColor: AppColors.of(context).transparent,
        elevation: 0,
        title: Text(
          'Story History',
          style: TextStyle(
            color: AppColors.of(context).white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.of(context).white),
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
            return  Center(
              child: CircularProgressIndicator(
                color: AppColors.of(context).limegreen,
              ),
            );
          }

          if (state is StoryFirestoreError) {
            return StoryErrorState(errorMessage: state.message);
          }

          if (state is StoryFirestoreLoaded) {
            final stories = state.stories;
            final filteredStories = _getFilteredStories(stories);

            if (stories.isEmpty) {
              return const StoryEmptyState();
            }

            if (filteredStories.isEmpty && _showOnlyFavorites) {
              return FavoritesEmptyState(
                onViewAll: () {
                  setState(() {
                    _showOnlyFavorites = false;
                  });
                },
              );
            }

            return StoryHistoryList(
              stories: filteredStories,
              onStoryTap: _openReader,
              onToggleFavorite: _toggleFavorite,
            );
          }

          return  Center(
            child: CircularProgressIndicator(
              color: AppColors.of(context).limegreen
            ),
          );
          },
        ),
      ),
    );
  }


  // Parça hesaplama ReaderPage'e taşındı

}