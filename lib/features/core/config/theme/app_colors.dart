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
  final Color sidebarColor;
  final Color onboardColor;
  final Color blueColor;
  final Color greyColor;
  const AppColors({
    required this.limegreen,
    required this.bacgroundblue,
    required this.ondarkliht,
    required this.blackd,
    required this.transparent,
    required this.rosePink,
    required this.white,
    required this.sidebarColor,
    required this.onboardColor,
    required this.blueColor,
    required this.greyColor,
  });

  static const AppColors light = AppColors(
    limegreen: Color(0xFF24FF00),
    bacgroundblue: Color(0xFF040116),
    ondarkliht: Color.fromARGB(255, 255, 255, 255),
    blackd: Color.fromARGB(255, 0, 0, 0),
    transparent: Colors.transparent,
    rosePink: Color.fromARGB(145, 255, 100, 113),
    white: Colors.white,
    sidebarColor: Color.fromARGB(255, 37, 37, 37),
    onboardColor: Color(0xFF040116),
    blueColor: Color(0xFF81B4FF),
    greyColor: Color(0xFF555555),
    );



  static const AppColors dark = AppColors(
    limegreen: Color.fromARGB(255, 252, 134, 152),
    bacgroundblue: Color(0xFF040116),
    ondarkliht: Color(0xFF040116),
    blackd: Color.fromARGB(255, 0, 0, 0),
    transparent: Colors.transparent,
    rosePink: Color.fromARGB(255, 252, 134, 152),
    white: Colors.white,
    sidebarColor: Color.fromARGB(255, 37, 37, 37),
    onboardColor:  Colors.white,
    blueColor: Color(0xFF81B4FF),
    greyColor: Color(0xFF555555),
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
    Color? sidebarColor,
    Color? onboardColor,
    Color? blueColor,
    Color? greyColor,
  }) {
    return AppColors(
      limegreen: limegreen ?? this.limegreen,
      bacgroundblue: bacgroundblue ?? this.bacgroundblue,
      ondarkliht: ondarkliht ?? this.ondarkliht,
      blackd: black ?? this.blackd,
      transparent: transparent ?? this.transparent,
      rosePink: rosePink ?? this.rosePink,
      white: white ?? this.white,
      sidebarColor: sidebarColor ?? this.sidebarColor,
      onboardColor: onboardColor ?? this.onboardColor,
      blueColor: blueColor ?? this.blueColor,
      greyColor: greyColor ?? this.greyColor,
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
      sidebarColor: Color.lerp(sidebarColor, other.sidebarColor, t)!,
      onboardColor: Color.lerp(onboardColor, other.onboardColor, t)!,
      blueColor: Color.lerp(blueColor, other.blueColor, t)!,
      greyColor: Color.lerp(greyColor, other.greyColor, t)!,
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