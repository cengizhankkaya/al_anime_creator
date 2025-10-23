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
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !isRegisterMode ? const Color(0xFFF77D8E) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Giriş Yap",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !isRegisterMode ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isRegisterMode ? const Color(0xFFF77D8E) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Kayıt Ol",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isRegisterMode ? Colors.white : Colors.black54,
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
