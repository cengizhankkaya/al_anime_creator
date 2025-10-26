import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/core/config/theme/app_colors.dart';

class SplashBackground extends StatelessWidget {
  final AppColors colors;
  const SplashBackground({Key? key, required this.colors}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: _Blob(color: colors.bacgroundblue.withOpacity(0.20), size: 260),
        ),
        Positioned(
          bottom: -120,
          right: -100,
          child: _Blob(color: colors.limegreen.withOpacity(0.10), size: 310),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BlobPainter(color: color),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;
  _BlobPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
