import 'package:al_anime_creator/features/core/config/theme/app_colors.dart';
import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:flutter/material.dart';

class ModeToggle extends StatelessWidget {
  final bool isRegisterMode;
  final ValueChanged<bool> onToggle;
  const ModeToggle({super.key, required this.isRegisterMode, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              padding:  ProjectPadding.verticalMedium,
              decoration: BoxDecoration(
                color: !isRegisterMode ? AppColors.of(context).limegreen : Theme.of(context).colorScheme.onSurface,
                borderRadius: ProjectRadius.medium,
              ),
              child: Text(
                "Giriş Yap",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !isRegisterMode ? AppColors.of(context).blackd   : Theme.of(context).colorScheme.surface ,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        ProjectSizedBox.widthSmall,
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              padding: ProjectPadding.verticalMedium,
              decoration: BoxDecoration(
                color: isRegisterMode ?  AppColors.of(context).limegreen  :  Theme.of(context).colorScheme.onSurface,
                borderRadius: ProjectRadius.medium,
              ),
              child: Text(
                "Kayıt Ol",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !isRegisterMode ? Theme.of(context).colorScheme.surface : AppColors.of(context).blackd ,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
