import 'package:flutter/material.dart';


/// App-specific semantic colors that are not covered by Material ColorScheme
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color limegreen;
  final Color bacgroundblue;
  final Color ondarkliht;
  final Color blackd;
  final Color transparent;
  final Color rosePink;
  final Color white;

  const AppColors({
    required this.limegreen,
    required this.bacgroundblue,
    required this.ondarkliht,
    required this.blackd,
    required this.transparent,
    required this.rosePink,
    required this.white,
  });

  static const AppColors light = AppColors(
    limegreen: Color(0xFF24FF00),
    bacgroundblue: Color(0xFF040116),
    ondarkliht: Color.fromARGB(255, 255, 255, 255),
    blackd: Color.fromARGB(255, 0, 0, 0),
    transparent: Colors.transparent,
    rosePink: Color.fromARGB(145, 255, 100, 113),
    white: Colors.white,
  );



  static const AppColors dark = AppColors(
    limegreen: Color.fromARGB(255, 252, 134, 152),
    bacgroundblue: Color(0xFF040116),
    ondarkliht: Color(0xFF040116),
    blackd: Color.fromARGB(255, 0, 0, 0),
    transparent: Colors.transparent,
    rosePink: Color.fromARGB(255, 252, 134, 152),
    white: Colors.white,
  );


  @override
  AppColors copyWith({
    Color? limegreen,
    Color? bacgroundblue,
    Color? ondarkliht,
    Color? black,
    Color? transparent,
    Color? rosePink,
    Color? white,
  }) {
    return AppColors(
      limegreen: limegreen ?? this.limegreen,
      bacgroundblue: bacgroundblue ?? this.bacgroundblue,
      ondarkliht: ondarkliht ?? this.ondarkliht,
      blackd: black ?? this.blackd,
      transparent: transparent ?? this.transparent,
      rosePink: rosePink ?? this.rosePink,
      white: white ?? this.white,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      limegreen: Color.lerp(limegreen, other.limegreen, t)!,
      bacgroundblue: Color.lerp(bacgroundblue, other.bacgroundblue, t)!,
      ondarkliht: Color.lerp(ondarkliht, other.ondarkliht, t)!,
      blackd: Color.lerp(blackd, other.blackd, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      rosePink: Color.lerp(rosePink, other.rosePink, t)!,
      white: Color.lerp(white, other.white, t)!,
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