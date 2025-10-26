import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/core/config/theme/app_colors.dart';

class SplashLogo extends StatelessWidget {
  final AppColors colors;
  const SplashLogo({Key? key, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: AlwaysStoppedAnimation(1.0), // Splash'tan animasyon taşınıyorsa burası değişebilir
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
