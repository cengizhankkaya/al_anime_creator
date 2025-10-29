import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/widgets/continue_story_dialog.dart';

/// Story history modülü için UI helper metodları
class StoryHistoryUIHelpers {
  /// Hata mesajı için snackbar gösterir
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    String? locale,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Başarı mesajı için snackbar gösterir
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    String? locale,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? const Color(0xFF24FF00),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Bilgi mesajı için snackbar gösterir
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    String? locale,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Locale'e göre çevrilmiş mesajlarla başarı snackbar'ı gösterir
  static void showChapterAddedSnackBar(
    BuildContext context, {
    String locale = 'en',
  }) {
    final message = locale == 'tr' ? 'Bölüm eklendi!' : 'Chapter added!';
    showSuccessSnackBar(context, message, locale: locale);
  }

  /// Locale'e göre çevrilmiş mesajlarla kısa bölüm uyarısı gösterir
  static void showShortChapterWarningSnackBar(
    BuildContext context, {
    String locale = 'en',
  }) {
    final message = locale == 'tr'
        ? 'Not: Yeni bölüm oldukça kısa geldi.'
        : 'Note: New chapter is very short.';
    showInfoSnackBar(context, message, locale: locale);
  }

  /// Locale'e göre çevrilmiş mesajlarla prompt uyarısı gösterir
  static void showPromptWarningSnackBar(
    BuildContext context, {
    String locale = 'en',
  }) {
    final message = locale == 'tr'
        ? 'Lütfen daha açıklayıcı bir istek girin.'
        : 'Please enter a more descriptive prompt.';
    showInfoSnackBar(context, message, locale: locale);
  }

  /// Continue story dialog'unu gösterir ve sonucu callback ile döner
  static Future<void> showContinueStoryDialog(
    BuildContext context, {
    required String locale,
    required Function(String) onContinue,
    Function()? onCancel,
  }) async {
    final continuationPrompt = await showDialog<String>(
      context: context,
      builder: (context) => ContinueStoryDialog(locale: locale),
    );

    if (continuationPrompt == null) {
      onCancel?.call();
      return;
    }

    final trimmedPrompt = continuationPrompt.trim();
    
    if (trimmedPrompt.length >= 8) {
      onContinue(trimmedPrompt);
    } else if (trimmedPrompt.isNotEmpty) {
      showPromptWarningSnackBar(context, locale: locale);
    }
  }
}

