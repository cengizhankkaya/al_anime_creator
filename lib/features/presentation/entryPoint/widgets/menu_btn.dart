import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MenuBtn extends StatelessWidget {
  const MenuBtn({super.key, required this.press, required this.riveOnInit});

  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final double iconSize = 40;
  final double blurRadius = 8;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: ProjectMargin.leftSmall,
          height: iconSize,
          width: iconSize,
          decoration: BoxDecoration(
            color:AppColors.of(context).white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.of(context).blackd.withValues(alpha: 0.1),
                offset: Offset(0, 3),
                blurRadius: blurRadius,
              ),
            ],
          ),
          child: RiveAnimation.asset(
            "assets/RiveAssets/menu_button.riv",
            onInit: riveOnInit,
          ),
        ),
      ),
    );
  }
}
