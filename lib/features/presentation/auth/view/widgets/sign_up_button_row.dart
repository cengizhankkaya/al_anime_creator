import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/auth/view/widgets/sign_up_icon_button.dart';

class SignUpButtonRow extends StatelessWidget {
  const SignUpButtonRow();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SignUpIconButton(svgAsset: "assets/icons/email_box.svg", onTap: () {}),
        SignUpIconButton(svgAsset: "assets/icons/apple_box.svg", onTap: () {}),
        SignUpIconButton(svgAsset: "assets/icons/google_box.svg", onTap: () {}),
      ],
    );
  }
}
