import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingAnim extends StatelessWidget {
  final void Function(Artboard) onInit;
  const LoadingAnim({super.key, required this.onInit});

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/RiveAssets/check.riv',
      fit: BoxFit.cover,
      onInit: onInit,
    );
  }
}
