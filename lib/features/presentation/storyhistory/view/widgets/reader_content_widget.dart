import 'package:flutter/material.dart';

/// Reader sayfasında story içeriğini gösteren widget
class ReaderContentWidget extends StatelessWidget {
  final String content;

  const ReaderContentWidget({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.6,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

