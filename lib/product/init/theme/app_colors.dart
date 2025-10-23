import 'package:flutter/material.dart';


/// App-specific semantic colors that are not covered by Material ColorScheme
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color limegreen;

  const AppColors({
    required this.limegreen, required Color bacgroundblue,
  });

  static const AppColors light = AppColors(
    limegreen: Color(0xFF24FF00),
    bacgroundblue: Color(0xFF040116),

  );



  static const AppColors dark = AppColors(
    bacgroundblue: Color(0xFF040116),
    limegreen: Color(0xFFCC8400),
  );


  @override
  AppColors copyWith({
    Color? limegreen,
  }) {
    return AppColors(
      limegreen: limegreen ?? this.limegreen, bacgroundblue: bacgroundblue ??  ,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      limegreen: Color.lerp(limegreen, other.limegreen, t)!, bacgroundblue: null,
    );
  }

  // Static method for easier access
  static AppColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    if (colors == null) {
      throw FlutterError(
        'AppColors extension not found. Make sure to add AppColors to your theme.',
      );
    }
    return colors;
  }
}