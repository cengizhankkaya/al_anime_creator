import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpIconButton extends StatelessWidget {
  final String svgAsset;
  final VoidCallback onTap;
  const SignUpIconButton({required this.svgAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      icon: SvgPicture.asset(svgAsset, height: 64, width: 64),
    );
  }
}
