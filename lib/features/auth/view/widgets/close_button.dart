import 'package:al_anime_creator/features/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: -48,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        child:  CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.of(context).limegreen,
          child: Icon(
            Icons.close,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
