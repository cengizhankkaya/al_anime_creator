import 'package:flutter/material.dart';

/// Story'nin ana görselini gösteren widget
class StoryImageWidget extends StatelessWidget {
  final String imageUrl;

  const StoryImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF24FF00), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x6624FF00),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
