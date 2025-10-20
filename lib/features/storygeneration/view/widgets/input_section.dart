import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _SectionHeader(
            title: title,
            subtitle: subtitle,
          ),
          _TextInputField(
            value: value,
            onChanged: onChanged,
            hintText: 'Enter $title details...',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Expandable logic kaldırıldı - artık hep açık
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.expand_more,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextInputField extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final String hintText;

  const _TextInputField({
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
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
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
