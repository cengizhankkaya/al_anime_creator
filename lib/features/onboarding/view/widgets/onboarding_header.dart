import 'package:flutter/material.dart';
import 'onboarding_constants.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 260,
      child: Column(
        children: [
          Text(
            kTitle,
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              height: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Text(kDescription),
        ],
      ),
    );
  }
}
