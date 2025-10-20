import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFF24FF00);

  static Color getSurfaceVariant(bool isActive) {
    return isActive ? accent : Colors.grey.shade800;
  }

  static Color getTextColor(bool isActive) {
    return isActive ? Colors.black : Colors.white;
  }
}
