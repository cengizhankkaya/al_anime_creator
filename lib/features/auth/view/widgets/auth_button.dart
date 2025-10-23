import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: const Color(0xFFF77D8E),
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
      icon: const Icon(
        CupertinoIcons.arrow_right,
        color: Color(0xFFFE0037),
      ),
      label: Text(isRegisterMode ? "Kayıt Ol" : "Giriş Yap"),
    );
  }
}
