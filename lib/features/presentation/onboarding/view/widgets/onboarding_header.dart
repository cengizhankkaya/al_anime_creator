import 'package:flutter/material.dart';
import 'onboarding_constants.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          Text(
            kTitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 60,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(kDescription,
          style: TextStyle(color: Theme.of(context).colorScheme.surface,),),
        ],
      ),
    );
  }
}
