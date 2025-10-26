import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';

class LengthSelector extends StatelessWidget {
  final int selectedLength;
  final Function(int) onLengthSelected;

  const LengthSelector({
    super.key,
    required this.selectedLength,
    required this.onLengthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LengthButton(
          text: 'Short',
          index: 0,
          isSelected: selectedLength == 0,
          onPressed: () => onLengthSelected(0),
        ),
        const SizedBox(width: 8),
        _LengthButton(
          text: 'Mid',
          index: 1,
          isSelected: selectedLength == 1,
          onPressed: () => onLengthSelected(1),
        ),
        const SizedBox(width: 8),
        _LengthButton(
          text: 'Long',
          index: 2,
          isSelected: selectedLength == 2,
          onPressed: () => onLengthSelected(2),
        ),
      ],
    );
  }
}

class _LengthButton extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final VoidCallback onPressed;

  const _LengthButton({
    required this.text,
    required this.index,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? AppColors.of(context).limegreen
              : AppColors.of(context).white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ?  AppColors.of(context).white :  AppColors.of(context).blackd,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
