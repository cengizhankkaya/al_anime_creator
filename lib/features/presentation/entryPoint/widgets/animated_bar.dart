import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: ProjectMargin.bottomSmall,
      duration: ProjectDuration.short,
      height: ProjectSize.barHeight,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
          color: AppColors.of(context).blueColor,
          borderRadius: ProjectRadius.large),
    );
  }
}
