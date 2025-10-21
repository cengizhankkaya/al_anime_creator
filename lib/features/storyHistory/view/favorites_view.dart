import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storyHistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/storyHistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/product/service/service_locator.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late StoryFirestoreCubit _storyCubit;
  int _currentChapterIndex = 0;

  @override
  void initState() {
    super.initState();
    _storyCubit = getIt<StoryFirestoreCubit>();
    // Favori hikayeleri yükle
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
    final formattedDate = _formatDate(story.createdAt);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _StoryReaderView(story: story, onToggleFavorite: _toggleFavorite),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF24FF00).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image with neon green border for favorites
              if (story.mainImageUrl != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF24FF00), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x6624FF00),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        story.mainImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (story.mainImageUrl != null) const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Favorite indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF24FF00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF24FF00),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      '★ Favori',
                      style: TextStyle(
                        color: Color(0xFF24FF00),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.book_outlined,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${story.chapters.length} ${story.chapters.length == 1 ? 'Bölüm' : 'Bölüm'}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      story.chapters.first.content.length > 80
                          ? '${story.chapters.first.content.substring(0, 80)}...'
                          : story.chapters.first.content,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF24FF00),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF24FF00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      story.settings.length,
                      style: const TextStyle(
                        color: Color(0xFF24FF00),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Hikaye okuyucu componenti
class _StoryReaderView extends StatefulWidget {
  final Story story;
  final Function(Story) onToggleFavorite;

  const _StoryReaderView({
    required this.story,
    required this.onToggleFavorite,
  });

  @override
  State<_StoryReaderView> createState() => _StoryReaderViewState();
}

class _StoryReaderViewState extends State<_StoryReaderView> {
  late List<String> _allParagraphs;
  late int _currentChapterIndex;

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = 0;
    _allParagraphs = _getAllParagraphs(widget.story);
  }

  void _nextChapter() {
    if (_currentChapterIndex < _allParagraphs.length - 1) {
      setState(() {
        _currentChapterIndex++;
      });
    }
  }

  void _previousChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentParagraph = _allParagraphs[_currentChapterIndex];
    final totalParagraphs = _allParagraphs.length;
    final isFirstChapter = _currentChapterIndex == 0;
    final isLastChapter = _currentChapterIndex == totalParagraphs - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.story.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
  BlocBuilder<StoryFirestoreCubit, StoryFirestoreState>(
    bloc: getIt<StoryFirestoreCubit>(), // veya _storyCubit
    builder: (context, state) {
      final isFavorite = state is StoryFirestoreLoaded
          ? state.stories.firstWhere((s) => s.id == widget.story.id).isFavorite
          : widget.story.isFavorite;

      return IconButton(
        onPressed: () => context.read<StoryFirestoreCubit>()
            .toggleFavoriteStory(widget.story.id, !isFavorite),
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? const Color(0xFF24FF00) : Colors.grey,
          size: 20,
        ),
      );
    },
  ),
],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Story metadata
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.story.settings.complexity,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(widget.story.createdAt),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Chapter image
            if (widget.story.chapters.isNotEmpty && widget.story.chapters.first.imageUrl != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.story.chapters.first.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Current paragraph
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                currentParagraph,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Chapter navigation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: isFirstChapter ? null : _previousChapter,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isFirstChapter ? Colors.grey : Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Sayfa ${_currentChapterIndex + 1} / $totalParagraphs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${currentParagraph.length} karakter',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: isLastChapter ? null : _nextChapter,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: isLastChapter ? Colors.grey : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Reading progress
            if (totalParagraphs > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Okuma İlerlemesi',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${((_currentChapterIndex + 1) / totalParagraphs * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Color(0xFF24FF00),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentChapterIndex + 1) / totalParagraphs,
                      backgroundColor: Colors.grey.shade800,
                      minHeight: 8,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF24FF00),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<String> _getAllParagraphs(Story story) {
    List<String> allPages = [];
    const int maxCharactersPerPage = 500;

    String fullContent = '';
    for (final chapter in story.chapters) {
      fullContent += chapter.content + '\n\n';
    }

    List<String> words = fullContent.split(' ');
    String currentPage = '';

    for (String word in words) {
      if ((currentPage + ' ' + word).length > maxCharactersPerPage && currentPage.isNotEmpty) {
        allPages.add(currentPage.trim());
        currentPage = word;
      } else {
        currentPage += (currentPage.isEmpty ? '' : ' ') + word;
      }
    }

    if (currentPage.trim().isNotEmpty) {
      allPages.add(currentPage.trim());
    }

    return allPages;
  }
}
