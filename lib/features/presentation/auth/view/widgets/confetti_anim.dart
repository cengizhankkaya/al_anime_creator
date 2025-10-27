import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ConfettiAnim extends StatelessWidget {
  final void Function(Artboard) onInit;
  const ConfettiAnim({super.key, required this.onInit});

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      "assets/RiveAssets/confetti.riv",
      onInit: onInit,
      fit: BoxFit.cover,
    );
  }
}
