
import 'package:flutter/material.dart';
import 'package:al_anime_creator/product/model/story.dart';
import 'package:al_anime_creator/features/storyHistory/view_model/story_history_viewmodel.dart';
import 'package:auto_route/annotations.dart';

@RoutePage(
  name: 'StoryHistoryRoute',
)
class StoryHistoryView extends StatefulWidget {
  const StoryHistoryView({super.key});

  @override
  State<StoryHistoryView> createState() => _StoryHistoryViewState();
}

class _StoryHistoryViewState extends State<StoryHistoryView> {
  late StoryHistoryViewModel _viewModel;
  int _currentChapterIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = StoryHistoryViewModel();
  }

  void _nextChapter() {
    if (_currentChapterIndex < (_viewModel.selectedStory?.chapters.length ?? 0) - 1) {
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

  void _resetToStoryList() {
    _viewModel.clearSelectedStory();
    _currentChapterIndex = 0;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF24FF00),
              ),
            );
          }

          if (_viewModel.stories.isEmpty) {
            return _buildEmptyState();
          }

          if (_viewModel.selectedStory != null) {
            return _buildChapterReader(_viewModel.selectedStory!);
          }

          return _buildStoriesList();
        },
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
              Navigator.of(context).pushReplacementNamed('StoryGenerationRoute');
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

  Widget _buildStoriesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _viewModel.stories.length,
      itemBuilder: (context, index) {
        final story = _viewModel.stories[index];
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
                    child: Text(
                      story.chapters.first.content.length > 80
                          ? '${story.chapters.first.content.substring(0, 80)}...'
                          : story.chapters.first.content,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom metadata row - moved lower
              Row(
                children: [
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
    final currentChapter = story.chapters[_currentChapterIndex];
    final totalChapters = story.chapters.length;
    final isFirstChapter = _currentChapterIndex == 0;
    final isLastChapter = _currentChapterIndex == totalChapters - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Header with story title and close button
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
          // Chapter image
          if (currentChapter.imageUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(currentChapter.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 16),
          // Chapter content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentChapter.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
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
                      'Chapter ${_currentChapterIndex + 1} of $totalChapters',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      currentChapter.title,
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
          // Chapter progress indicator
          if (totalChapters > 1)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chapter Progress',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (_currentChapterIndex + 1) / totalChapters,
                    backgroundColor: Colors.grey.shade800,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF24FF00),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_currentChapterIndex + 1} of $totalChapters chapters read',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
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
                onPressed: () => _viewModel.deleteStory(story.id),
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
}