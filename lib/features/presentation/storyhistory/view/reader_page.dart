import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/date_formatter.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/text_paginator.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/widgets/continue_story_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';

class ReaderPage extends StatefulWidget {
  final Story story;
  final void Function(Story) onToggleFavorite;
  final String locale;

  const ReaderPage({
    super.key,
    required this.story,
    required this.onToggleFavorite,
    this.locale = 'en',
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late List<String> _pages;
  int _index = 0;
  bool _isContinuing = false; // Yükleme state'i

  @override
  void initState() {
    super.initState();
    _refreshPages();
  }

  void _refreshPages({Story? story}) {
    final targetStory = story ?? widget.story;
    final buffer = StringBuffer();
    for (final c in targetStory.chapters) {
      buffer.write(c.content);
      buffer.write('\n\n');
    }
    final paginated = TextPaginator.paginate(buffer.toString(), maxCharactersPerPage: 500);
    setState(() {
      _pages = paginated;
      if (story != null) {
        _index = _pages.length - 1; // Son sayfaya git
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _pages.length;
    final isFirst = _index == 0;
    final isLast = _index == total - 1;
    final current = _pages[_index];

    return BlocListener<StoryGenerationCubit, StoryGenerationState>(
      listener: (context, state) {
        if (state is StoryGenerationLoading) {
          setState(() { _isContinuing = true; });
        } else if (state is StoryGenerationLoaded) {
          setState(() { _isContinuing = false; });
          _refreshPages(story: state.savedStory);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.locale == 'tr' ? 'Bölüm eklendi!' : 'Chapter added!'),
              backgroundColor: const Color(0xFF24FF00),
            ),
          );
          final added = state.savedStory.chapters.last;
          if (added.content.trim().length < 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.locale == 'tr'
                    ? 'Not: Yeni bölüm oldukça kısa geldi.'
                    : 'Note: New chapter is very short.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else if (state is StoryGenerationError) {
          setState(() { _isContinuing = false; });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
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
            if (widget.story.settings.length.toLowerCase() == 'long')
              IconButton(
                onPressed: _isContinuing ? null : () => _autoContinueStory(),
                icon: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF24FF00),
                  size: 20,
                ),
                tooltip: widget.locale == 'tr' ? 'Otomatik Devam Et' : 'Auto Continue',
              ),
            IconButton(
              onPressed: _isContinuing ? null : () => _showContinueStoryDialog(context),
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xFF24FF00),
                size: 20,
              ),
              tooltip: widget.locale == 'tr' ? 'Hikayeyi Devam Ettir' : 'Continue Story',
            ),
            IconButton(
              onPressed: () => widget.onToggleFavorite(widget.story),
              icon: Icon(
                widget.story.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.story.isFavorite ? const Color(0xFF24FF00) : Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _complexityColor(widget.story.settings.complexity).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _complexityColor(widget.story.settings.complexity),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.story.settings.complexity,
                          style: TextStyle(
                            color: _complexityColor(widget.story.settings.complexity),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatter.relativeOrDate(widget.story.createdAt, locale: widget.locale),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      current,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          onPressed: isFirst ? null : () => setState(() => _index--),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: isFirst ? Colors.grey : Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              (widget.locale == 'tr') ? 'Sayfa  ${_index + 1} / $total' : 'Page ${_index + 1} of $total',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${current.length} ${widget.locale == 'tr' ? 'karakter' : 'characters'}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: isLast ? null : () => setState(() => _index++),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: isLast ? Colors.grey : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (total > 0)
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
                                widget.locale == 'tr' ? 'Okuma İlerlemesi' : 'Reading Progress',
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${((_index + 1) / total * 100).toStringAsFixed(0)}%',
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
                            value: (_index + 1) / total,
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
            if (_isContinuing)
              Container(
                color: Colors.black.withOpacity(0.40),
                child: const Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF24FF00))),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _complexityColor(String complexity) {
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

  void _showContinueStoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ContinueStoryDialog(locale: widget.locale),
    ).then((continuationPrompt) {
      if (continuationPrompt != null && continuationPrompt is String && continuationPrompt.trim().length >= 8) {
        _continueStory(continuationPrompt);
      } else if (continuationPrompt != null && continuationPrompt is String && continuationPrompt.trim().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.locale == 'tr' ? 'Lütfen daha açıklayıcı bir istek girin.' : 'Please enter a more descriptive prompt.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  void _continueStory(String continuationPrompt) {
    final storyGenerationCubit = context.read<StoryGenerationCubit>();
    storyGenerationCubit.continueStory(widget.story, continuationPrompt);
  }

  void _autoContinueStory() {
    final storyGenerationCubit = context.read<StoryGenerationCubit>();
    storyGenerationCubit.autoContinueStory(widget.story);
  }
}


