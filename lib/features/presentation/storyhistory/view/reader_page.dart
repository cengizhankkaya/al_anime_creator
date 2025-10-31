import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/text_paginator.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/story_history_ui_helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_state.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/reader_header_widget.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/reader_image_widget.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/reader_content_widget.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/reader_navigation_widget.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/widgets/reader_progress_widget.dart';

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
      buffer.write(_cleanMarkdownCharacters(c.content));
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

  /// Markdown karakterlerini (* ve #) temizler
  String _cleanMarkdownCharacters(String content) {
    String text = content;
    // * karakterlerini kaldır (markdown bold ve list işaretleri için)
    text = text.replaceAll(RegExp(r'\*+'), '');
    // # karakterlerini kaldır (markdown başlık işaretleri için)
    text = text.replaceAll(RegExp(r'#+\s*'), '');
    return text;
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
          StoryHistoryUIHelpers.showChapterAddedSnackBar(context, locale: widget.locale);
          final added = state.savedStory.chapters.last;
          if (added.content.trim().length < 200) {
            StoryHistoryUIHelpers.showShortChapterWarningSnackBar(context, locale: widget.locale);
          }
        } else if (state is StoryGenerationError) {
          setState(() { _isContinuing = false; });
          StoryHistoryUIHelpers.showErrorSnackBar(context, state.message, locale: widget.locale);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.of(context).bacgroundblue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:  Icon(Icons.arrow_back, color: AppColors.of(context).white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.story.title,
            style:  TextStyle(
              color: AppColors.of(context).white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (widget.story.settings.length.toLowerCase() == 'long')
              IconButton(
                onPressed: _isContinuing ? null : () => _autoContinueStory(),
                icon: Icon(
                  Icons.auto_awesome,
                  color: AppColors.of(context).limegreen,
                  size: 20,
                ),
                tooltip: widget.locale == 'tr' ? 'Otomatik Devam Et' : 'Auto Continue',
              ),
            IconButton(
              onPressed: _isContinuing ? null : () => _showContinueStoryDialog(context),
              icon: Icon(
                Icons.add_circle_outline,
                color: AppColors.of(context).limegreen,
                size: 20,
              ),
              tooltip: widget.locale == 'tr' ? 'Hikayeyi Devam Ettir' : 'Continue Story',
            ),
            IconButton(
              onPressed: () => widget.onToggleFavorite(widget.story),
              icon: Icon(
                widget.story.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.story.isFavorite ? AppColors.of(context).limegreen : Colors.grey,
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
                  ReaderHeaderWidget(
                    story: widget.story,
                    locale: widget.locale,
                  ),
                  const SizedBox(height: 16),
                  if (widget.story.chapters.isNotEmpty && widget.story.chapters.first.imageUrl != null) ...[
                    ReaderImageWidget(imageUrl: widget.story.chapters.first.imageUrl!),
                    const SizedBox(height: 16),
                  ],
                  ReaderContentWidget(content: current),
                  const SizedBox(height: 16),
                  ReaderNavigationWidget(
                    currentPage: _index,
                    totalPages: total,
                    currentContentLength: current.length,
                    isFirst: isFirst,
                    isLast: isLast,
                    onPrevious: () => setState(() => _index--),
                    onNext: () => setState(() => _index++),
                    locale: widget.locale,
                  ),
                  const SizedBox(height: 24),
                  if (total > 0)
                    ReaderProgressWidget(
                      currentPage: _index,
                      totalPages: total,
                      locale: widget.locale,
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


  void _showContinueStoryDialog(BuildContext context) {
    StoryHistoryUIHelpers.showContinueStoryDialog(
      context,
      locale: widget.locale,
      onContinue: _continueStory,
    );
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


