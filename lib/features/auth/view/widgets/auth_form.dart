import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/auth/view/widgets/email_text_field.dart';
import 'package:al_anime_creator/features/auth/view/widgets/password_text_field.dart';
import 'package:al_anime_creator/features/auth/view/widgets/auth_button.dart';
import 'package:al_anime_creator/features/auth/view/widgets/mode_toggle.dart';

class AuthForm extends StatefulWidget {
  final bool isRegisterMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function(bool isRegisterMode)? onToggleMode;
  final void Function()? onSubmit;

  const AuthForm({
    super.key,
    required this.isRegisterMode,
    required this.emailController,
    required this.passwordController,
    this.onToggleMode,
    this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModeToggle(
            isRegisterMode: widget.isRegisterMode,
            onToggle: (val) {
              widget.onToggleMode?.call(val);
            },
          ),
          const SizedBox(height: 24),
          const Text("Email", style: TextStyle(color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: EmailTextField(emailController: widget.emailController),
          ),
          const Text(
            "Password",
            style: TextStyle(color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: PasswordTextField(passwordController: widget.passwordController),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: AuthButton(
              isRegisterMode: widget.isRegisterMode,
              onPressed: () {
                // Validasyon başarılıysa onSubmit'i tetikle
                if (_formKey.currentState?.validate() == true) {
                  widget.onSubmit?.call();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
