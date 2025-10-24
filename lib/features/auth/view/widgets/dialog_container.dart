
import 'package:al_anime_creator/product/init/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'divider_with_or_text.dart';
import 'sign_up_button_row.dart';
import 'close_button.dart';
import '../sign_in.dart';

class DialogContainer extends StatelessWidget {
  const DialogContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.of(context).ondarkliht,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 30),
            blurRadius: 60,
          ),
        ],
      ),
      child: Material(
        color: AppColors.of(context).transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "AL Anime Creator",
                    style: TextStyle(
                      fontSize: 34,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "AI Anime Creator ile yapay zekâ desteğiyle kendi sahnelerini ve hikâyelerini oluştur.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  SignInForm(),
                  const DividerWithOrText(),
                   Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "E-posta, Apple veya Google ile kaydol.",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SignUpButtonRow(),
                ],
              ),
            ),
            const CloseButtonWidget(),
          ],
        ),
      ),
    );
  }
}
