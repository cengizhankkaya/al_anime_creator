import 'package:flutter/material.dart';

/// Reader sayfasında story görselini gösteren widget
class ReaderImageWidget extends StatelessWidget {
  final String imageUrl;

  const ReaderImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

