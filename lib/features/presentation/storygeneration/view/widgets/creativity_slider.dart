import 'package:flutter/material.dart';

class CreativitySlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const CreativitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SliderLabel(
              text: 'Standart',
              isActive: value <= -0.3,
            ),
            _SliderLabel(
              text: 'Karmaşık',
              isActive: value.abs() <= 0.3,
            ),
            _SliderLabel(
              text: 'Yenilikçi',
              isActive: value >= 0.3,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: -1,
            max: 1,
            divisions: 2,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SliderLabel extends StatelessWidget {
  final String text;
  final bool isActive;

  const _SliderLabel({
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.grey,
        fontSize: 16,
      ),
    );
  }
}
