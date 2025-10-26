
import 'package:al_anime_creator/features/core/config/theme/custom_color_sheme.dart';
import 'package:al_anime_creator/features/core/config/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Custom light theme for project design
final class CustomDarkTheme implements CustomTheme {
  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: CustomColorScheme.darkColorScheme,
        floatingActionButtonTheme: floatingActionButtonThemeData,
        extensions: <ThemeExtension<dynamic>>[
          AppColors.dark,
        ],
      );

  @override
  final FloatingActionButtonThemeData floatingActionButtonThemeData =
      const FloatingActionButtonThemeData();
}