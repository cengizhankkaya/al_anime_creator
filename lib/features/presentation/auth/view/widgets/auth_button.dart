



import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final bool isRegisterMode;
  final VoidCallback onPressed;
  const AuthButton({
    super.key,
    required this.isRegisterMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:   AppColors.of(context).onboardColor,
        minimumSize: ProjectSize.buttonMin,
        shape:  RoundedRectangleBorder(
          borderRadius: ProjectRadius.topOnly,
        ),
      ),
      icon: Icon(
        CupertinoIcons.arrow_right,
        color: AppColors.of(context).ondarkliht,
      ),
      label: Text(isRegisterMode ? "Kayıt Ol" : "Giriş Yap", style: TextStyle(color: AppColors.of(context).ondarkliht),),
    );
  }
}
