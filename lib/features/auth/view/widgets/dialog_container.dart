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
        color: Colors.white.withOpacity(0.95),
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
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Giriş Yap / Kayıt Ol",
                    style: TextStyle(
                      fontSize: 34,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "240+ saatlik içeriğe erişim. Gerçek uygulamalar geliştirerek tasarım ve kod öğren.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SignInForm(),
                  const DividerWithOrText(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "E-posta, Apple veya Google ile kaydol.",
                      style: TextStyle(color: Colors.black54),
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
