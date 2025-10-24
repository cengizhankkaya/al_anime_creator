import 'package:al_anime_creator/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:al_anime_creator/features/auth/view/widgets/auth_listener.dart';
import 'package:al_anime_creator/features/auth/view/widgets/loading_anim.dart';
import 'package:al_anime_creator/features/auth/view/widgets/confetti_anim.dart';
import 'package:al_anime_creator/features/auth/view/widgets/auth_form.dart';
import 'package:al_anime_creator/features/auth/view/widgets/custom_positioned.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  bool isRegisterMode = false;
  SMITrigger? error;
  SMITrigger? success;
  SMITrigger? reset;

  SMITrigger? confetti;

  void _onCheckRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (controller == null) return;

    artboard.addController(controller);
    error = controller.findInput<bool>('Error') as SMITrigger?;
    success = controller.findInput<bool>('Check') as SMITrigger?;
    reset = controller.findInput<bool>('Reset') as SMITrigger?;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    );
    if (controller == null) return;
    artboard.addController(controller);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger?;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) => authListener(
        context,
        state,
        isShowLoading,
        (value) => setState(() => isShowLoading = value),
        error,
        reset,
        () => confetti?.fire(),
        (value) => setState(() => isShowConfetti = value),
      ),
      builder: (context, state) {
        return Stack(
          children: [
            AuthForm(
              isRegisterMode: isRegisterMode,
              emailController: emailController,
              passwordController: passwordController,
              nameController: nameController,
              onToggleMode: (val) => setState(() => isRegisterMode = val),
              onSubmit: () {
                if (isRegisterMode) {
                  context.read<AuthCubit>().register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    nameController.text.trim(),
                  );
                } else {
                  context.read<AuthCubit>().login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                }
              },
            ),
            isShowLoading
                ? CustomPositioned(child: LoadingAnim(onInit: _onCheckRiveInit))
                : const SizedBox(),
            isShowConfetti
                ? CustomPositioned(scale: 6, child: ConfettiAnim(onInit: _onConfettiRiveInit))
                : const SizedBox(),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
