import 'dart:ui'; // ImageFilter için eklendi
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:al_anime_creator/product/init/navigation/app_router.dart';
import 'package:al_anime_creator/product/init/theme/app_colors.dart';

@RoutePage(name: 'SplashRoute')
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    Future.delayed(const Duration(milliseconds: 2000), _checkAuthStatus);
  }

  void _checkAuthStatus() {
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.router.replace(const EntryPointRoute());
    } else {
      context.router.replace(const OnboardingRoute());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bacgroundblue,
      body: Stack(
        children: [
          _buildBackgroundBlobs(colors),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogoAndText(context),
                  const SizedBox(height: 50),
                  // loader kısmı:
                  CustomLinearLoader(
                    color: colors.limegreen,
                    width: 120,
                    height: 7,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlobs(AppColors colors) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: _Blob(
            color: colors.bacgroundblue.withOpacity(0.20),
            size: 260,
          ),
        ),
        Positioned(
          bottom: -120,
          right: -100,
          child: _Blob(
            color: colors.limegreen.withOpacity(0.10),
            size: 310,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoAndText(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sade Logo
        ScaleTransition(
          scale: _fadeAnimation,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.bacgroundblue,
              border: Border.all(
                color: colors.limegreen.withOpacity(0.25),
                width: 2.4,
              ),
              // gradient VEYA shadow'u kaldırdık, arkaplan sabit
            ),
            child: Icon(
              Icons.auto_awesome_sharp,
              size: 48,
              color: colors.limegreen,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'AL Anime Creator',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.white,
            letterSpacing: 1.4,
            shadows: [],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Yaratıcılığın Başlıyor...',
          style: textTheme.titleMedium?.copyWith(
            color: colors.limegreen.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// Arka plan 'blob'larını çizen basit bir yardımcı widget
class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
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
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100); // Yüksek blur
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Loader:
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