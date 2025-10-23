import 'package:flutter/material.dart';

class DividerWithOrText extends StatelessWidget {
  const DividerWithOrText();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "VEYA",
            style: TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
