import 'package:flutter/material.dart';

class CustomLinearLoader extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  const CustomLinearLoader({
    Key? key,
    required this.color,
    this.width = 120,
    this.height = 7,
  }) : super(key: key);
  @override
  State<CustomLinearLoader> createState() => _CustomLinearLoaderState();
}
class _CustomLinearLoaderState extends State<CustomLinearLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _LinearLoadingPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _LinearLoadingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _LinearLoadingPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint base = Paint()
      ..color = color.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    final Paint fg = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final barRadius = Radius.circular(size.height / 2);
    final bgRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      barRadius,
    );
    canvas.drawRRect(bgRect, base);
    final double block = size.width * 0.30;
    final double start = (size.width + block) * progress - block;
    final fgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(start, 0, block, size.height),
      barRadius,
    );
    canvas.drawRRect(fgRect, fg);
  }
  @override
  bool shouldRepaint(_LinearLoadingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
