import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: -48,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        child: const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.close,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
