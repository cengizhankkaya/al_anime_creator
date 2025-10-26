import 'dart:ui';

import 'package:al_anime_creator/features/presentation/onboarding/view/widgets/onboarding_header.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;

import '../../../core/config/theme/app_colors.dart';
import 'widgets/animated_btn.dart';
import 'package:al_anime_creator/features/auth/view/sign_in_dialog.dart';
import 'widgets/onboarding_constants.dart';

@RoutePage(
  name: 'OnboardingRoute',
)
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late RiveAnimationController _btnAnimationController;
  bool isShowSignInDialog = false;

  @override
  void initState() {
    super.initState();
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
  }

  void _showSignInDialog() {
    setState(() {
      isShowSignInDialog = true;
    });
    if (!context.mounted) return;
    showCustomDialog(
      context,
      onValue: (_) {/*Burada istediğiniz ek işlemi ekleyebilirsiniz*/},
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
      color: AppColors.of(context).onboardColor,
    ),
          _buildBackground(size),
          _buildBlur(sigma: 20),
          const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
          _buildBlur(sigma: 30),
          _buildAnimatedContent(context, size),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size) => Positioned(
        width: size.width * 1.7,
        left: 100,
        bottom: 100,
        child: Image.asset("assets/Backgrounds/Spline.png"),
      );

  Widget _buildBlur({required double sigma}) => Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: const SizedBox(),
        ),
      );

  Widget _buildAnimatedContent(BuildContext context, Size size) => AnimatedPositioned(
        top: isShowSignInDialog ? -50 : 0,
        height: size.height,
        width: size.width,
        duration: const Duration(milliseconds: 260),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const OnboardingHeader(),
                const Spacer(flex: 2),
                AnimatedBtn(
                  btnAnimationController: _btnAnimationController,
                  press: () {
                    _btnAnimationController.isActive = true;
                    Future.delayed(const Duration(milliseconds: 800), _showSignInDialog);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(kPurchaseDetails, style: TextStyle(color: Theme.of(context).colorScheme.surface,)),
                )
              ],
            ),
          ),
        ),
      );
}
