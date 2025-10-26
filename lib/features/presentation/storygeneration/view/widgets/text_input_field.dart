import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/core/config/theme/app_colors.dart';

class TextInputField extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final String hintText;

  const TextInputField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.of(context).white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.collapsed(offset: value.length),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: const TextStyle(color: Colors.white),
        maxLines: 3,
      ),
    );
  }
}
