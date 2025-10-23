import 'package:flutter/material.dart';

/// Animasyon overlaylarını kolayca ortalamak ve pozisyonlamak için genel çözüm.
class CustomPositioned extends StatelessWidget {
  final double scale;
  final Widget child;
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(scale: scale, child: child),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
