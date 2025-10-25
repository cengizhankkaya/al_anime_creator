import 'package:flutter/material.dart';
import 'package:al_anime_creator/product/init/theme/app_colors.dart';
import 'section_header.dart';
import 'text_input_field.dart';

class InputSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final String value;
  final Function(String) onChanged;

  const InputSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).limegreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:AppColors.of(context).limegreen,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: widget.title,
            subtitle: widget.subtitle,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            TextInputField(
              value: widget.value,
              onChanged: widget.onChanged,
              hintText: 'Enter ${widget.title} details...',
            ),
        ],
      ),
    );
  }
}
