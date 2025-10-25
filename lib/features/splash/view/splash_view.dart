import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:al_anime_creator/product/init/navigation/app_router.dart';
import 'package:al_anime_creator/product/init/theme/app_colors.dart';
import 'widgets/splash_background.dart';
import 'widgets/splash_logo.dart';
import 'widgets/splash_loader.dart';

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
    return Scaffold(
      backgroundColor: colors.bacgroundblue,
      body: Stack(
        children: [
          SplashBackground(colors: colors),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SplashLogo(colors: colors),
                  const SizedBox(height: 50),
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
}