import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/utils/story_history_ui_helpers.dart';

/// Story history UI işlemleri için extension metodları
/// Bu extension'lar kodu daha okunabilir hale getirir
/// 
/// Örnek kullanım:
/// ```dart
/// context.showChapterAddedSnackBar(locale: 'tr');
/// ```
extension StoryHistoryUIExtensions on BuildContext {
  /// Başarı snackbar'ı gösterir
  void showSuccessSnackBar(String message, {Color? backgroundColor}) {
    StoryHistoryUIHelpers.showSuccessSnackBar(
      this,
      message,
      backgroundColor: backgroundColor,
    );
  }

  /// Hata snackbar'ı gösterir
  void showErrorSnackBar(String message) {
    StoryHistoryUIHelpers.showErrorSnackBar(this, message);
  }

  /// Bilgi snackbar'ı gösterir
  void showInfoSnackBar(String message) {
    StoryHistoryUIHelpers.showInfoSnackBar(this, message);
  }

  /// Bölüm eklendi snackbar'ı gösterir
  void showChapterAddedSnackBar({String locale = 'en'}) {
    StoryHistoryUIHelpers.showChapterAddedSnackBar(this, locale: locale);
  }

  /// Kısa bölüm uyarısı snackbar'ı gösterir
  void showShortChapterWarningSnackBar({String locale = 'en'}) {
    StoryHistoryUIHelpers.showShortChapterWarningSnackBar(this, locale: locale);
  }

  /// Continue story dialog'unu gösterir
  Future<void> showContinueStoryDialog({
    required String locale,
    required Function(String) onContinue,
    Function()? onCancel,
  }) {
    return StoryHistoryUIHelpers.showContinueStoryDialog(
      this,
      locale: locale,
      onContinue: onContinue,
      onCancel: onCancel,
    );
  }
}

