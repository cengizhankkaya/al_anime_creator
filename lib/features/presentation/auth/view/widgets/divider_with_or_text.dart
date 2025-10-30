import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';

class DividerWithOrText extends StatelessWidget {
  const DividerWithOrText();
  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        Expanded(child: Divider()),
        Padding(
          padding: ProjectPadding.symmetricHorizontalNormal,
          child: Text(
            "VEYA",
            style: TextStyle(
              color: AppColors.of(context).onboardColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
