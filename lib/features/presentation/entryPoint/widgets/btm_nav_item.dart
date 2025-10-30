import 'package:al_anime_creator/features/presentation/entryPoint/menu.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'animated_bar.dart';

class BtmNavItem extends StatelessWidget {
   BtmNavItem(
      {super.key,
      required this.navBar,
      required this.press,
      required this.riveOnInit,
      required this.selectedNav});

  final Menu navBar;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedNav;
  final double iconSize = 36;

  @override

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBar(isActive: selectedNav == navBar),
          SizedBox(
            height: iconSize,
            width: iconSize,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                selectedNav == navBar ? colorScheme.surface : colorScheme.surface.withValues(alpha: 0.6),
                selectedNav == navBar ? BlendMode.srcATop : BlendMode.modulate,
              ),
              child: Opacity(
                opacity: selectedNav == navBar ? 1 : 0.4,
                child: RiveAnimation.asset(
                  navBar.rive.src,
                  artboard: navBar.rive.artboard,
                  onInit: riveOnInit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
