



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../product/init/theme/app_colors.dart';

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
        backgroundColor:   AppColors.of(context).bacgroundblue,
        minimumSize: const Size(double.infinity, 56),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      icon: Icon(
        CupertinoIcons.arrow_right,
        color: Theme.of(context).colorScheme.surface,
      ),
      label: Text(isRegisterMode ? "Kayıt Ol" : "Giriş Yap", style: TextStyle(color: Theme.of(context).colorScheme.surface),),
    );
  }
}
