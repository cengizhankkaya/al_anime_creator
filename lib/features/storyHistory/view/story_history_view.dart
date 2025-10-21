
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/features/storyHistory/view_model/story_history_viewmodel.dart';
import 'package:al_anime_creator/features/storyHistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/storyHistory/cubit/story_firestore_state.dart';
import 'package:al_anime_creator/product/service/service_locator.dart';
import 'package:al_anime_creator/product/init/navigation/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_route/annotations.dart';

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
  late StoryHistoryViewModel _viewModel;
  int _currentChapterIndex = 0;
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<StoryHistoryViewModel>();
    // Firebase'den hikayeleri yükle
    context.read<StoryFirestoreCubit>().loadStories();

    // Eğer initialStoryId varsa, hikayeler yüklendikten sonra otomatik seç
    if (widget.initialStoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoSelectStory(widget.initialStoryId!);
      });
    }
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

  void _nextChapter() {
    if (_viewModel.selectedStory != null) {
      final allParagraphs = _getAllParagraphs(_viewModel.selectedStory!);
      if (_currentChapterIndex < allParagraphs.length - 1) {
        setState(() {
          _currentChapterIndex++;
        });
      }
    }
  }

  void _previousChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
      });
    }
  }

  void _resetToStoryList() {
    _viewModel.clearSelectedStory();
    _currentChapterIndex = 0;
  }

  void _autoSelectStory(String storyId) {
    // Hikayeler yüklenene kadar bekle ve belirtilen ID'li hikayeyi seç
    final stories = _viewModel.stories;
    if (stories.isNotEmpty) {
      final story = stories.where((s) => s.id == storyId).firstOrNull;
      if (story != null) {
        _viewModel.selectStory(story);
        _currentChapterIndex = 0;
      }
    }
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
            // Hikaye silindiğinde ViewModel'deki hikayeyi kaldır
            _viewModel.deleteStorySync(state.storyId);
            // Hikayeler listesini yeniden yükle
            context.read<StoryFirestoreCubit>().loadStories();
          }
        },
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            return BlocBuilder<StoryFirestoreCubit, StoryFirestoreState>(
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

            if (_viewModel.selectedStory != null) {
              return _buildChapterReader(_viewModel.selectedStory!);
            }

            return _buildStoriesList(filteredStories);
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF24FF00),
            ),
          );
              },
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
    final formattedDate = _formatDate(story.createdAt);

    return GestureDetector(
      onTap: () => _viewModel.selectStory(story),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image with neon green border
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getComplexityColor(story.settings.complexity).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getComplexityColor(story.settings.complexity),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      story.settings.complexity,
                      style: TextStyle(
                        color: _getComplexityColor(story.settings.complexity),
                        fontSize: 12,
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
                    '${story.chapters.length} ${story.chapters.length == 1 ? 'Chapter' : 'Chapters'}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom row with favorite button and arrow
              Row(
                children: [
                  // Favorite button
                  IconButton(
                    onPressed: () => _toggleFavorite(story),
                    icon: Icon(
                      story.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: story.isFavorite ? const Color(0xFF24FF00) : Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Story metadata moved to bottom
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

  Widget _buildChapterReader(Story story) {
    // Paragrafları bölüm olarak işle
    final allParagraphs = _getAllParagraphs(story);
    final currentParagraph = allParagraphs[_currentChapterIndex];
    final totalParagraphs = allParagraphs.length;
    final isFirstChapter = _currentChapterIndex == 0;
    final isLastChapter = _currentChapterIndex == totalParagraphs - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
              // Header with story title, favorite button and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _resetToStoryList,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _toggleFavorite(story),
                    icon: Icon(
                      story.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: story.isFavorite ? const Color(0xFF24FF00) : Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 8),
          // Story metadata
          Row(
            children: [
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getComplexityColor(story.settings.complexity).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getComplexityColor(story.settings.complexity),
                    width: 1,
                  ),
                ),
                child: Text(
                  story.settings.complexity,
                  style: TextStyle(
                    color: _getComplexityColor(story.settings.complexity),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(story.createdAt),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chapter image (use first chapter's image if available)
          if (story.chapters.isNotEmpty && story.chapters.first.imageUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(story.chapters.first.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 16),
          // Current paragraph as a section
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
                      'Page ${_currentChapterIndex + 1} of $totalParagraphs',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${currentParagraph.length} characters',
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
          // Book-style page progress indicator
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
                      Text(
                        'Reading Progress',
                        style: TextStyle(
                          color: Colors.grey.shade300,
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
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Page ${_currentChapterIndex + 1} of $totalParagraphs',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.read<StoryFirestoreCubit>().deleteStory(story.id),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }



  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getComplexityColor(String complexity) {
    switch (complexity.toLowerCase()) {
      case 'creative':
        return const Color(0xFF24FF00);
      case 'complex':
        return Colors.orange;
      case 'standard':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<String> _getAllParagraphs(Story story) {
    List<String> allPages = [];
    const int maxCharactersPerPage = 500; // Her sayfa için maksimum karakter sayısı
    
    // Tüm bölümlerin içeriğini birleştir
    String fullContent = '';
    for (final chapter in story.chapters) {
      fullContent += chapter.content + '\n\n';
    }
    
    // İçeriği sayfalara böl
    List<String> words = fullContent.split(' ');
    String currentPage = '';
    
    for (String word in words) {
      // Yeni sayfa eklenirse karakter sayısını kontrol et
      if ((currentPage + ' ' + word).length > maxCharactersPerPage && currentPage.isNotEmpty) {
        allPages.add(currentPage.trim());
        currentPage = word;
      } else {
        currentPage += (currentPage.isEmpty ? '' : ' ') + word;
      }
    }
    
    // Son sayfayı ekle
    if (currentPage.trim().isNotEmpty) {
      allPages.add(currentPage.trim());
    }
    
    return allPages;
  }

}