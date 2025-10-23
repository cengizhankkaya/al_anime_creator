import 'package:al_anime_creator/features/auth/cubit/auth_cubit.dart';
import 'package:al_anime_creator/product/init/navigation/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  void signIn(BuildContext context) {
  // Form geçerli değilse hata animasyonu
  if (!_formKey.currentState!.validate()) {
    error?.fire();
    Future.delayed(const Duration(seconds: 2), () {
      reset?.fire();
    });
    return; // Burada fonksiyon bitmeli
  }

  // Form geçerli ise loading başlat
  setState(() {
    isShowLoading = true;
    isShowConfetti = true;
  });

  // 🔹 Cubit login veya register çağrısı
  if (isRegisterMode) {
    context.read<AuthCubit>().register(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
  } else {
    context.read<AuthCubit>().login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
  }

  // 🔹 Animasyon ve yönlendirme Cubit listener içinde yönetilecek
}

 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && isShowLoading) {
          setState(() {
            isShowLoading = false;
          });
          if (!context.mounted) return;
          // Önce dialogu kapat, ardından root navigator üzerinden yönlendir
          Navigator.of(context, rootNavigator: true).pop();
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!context.mounted) return;
            context.router.replace(const EntryPointRoute());
          });
    } else if (state is AuthFailure) {
      error?.fire();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isShowLoading = false;
        });
        reset?.fire();
      });
    } else if (state is AuthLoading) {
      setState(() {
        isShowLoading = true;
      });
    }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Register/Sign In Toggle
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRegisterMode = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isRegisterMode ? const Color(0xFFF77D8E) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Giriş Yap",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isRegisterMode ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRegisterMode = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isRegisterMode ? const Color(0xFFF77D8E) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Kayıt Ol",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isRegisterMode ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Email", style: TextStyle(color: Colors.black54)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) =>
                          value!.isEmpty ? " Email boş olamaz" : null,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SvgPicture.asset("assets/icons/email.svg"),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? " Parola boş olamaz" : null,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SvgPicture.asset("assets/icons/password.svg"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        signIn(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF77D8E),
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Color(0xFFFE0037),
                      ),
                      label: Text(isRegisterMode ? "Kayıt Ol" : "Giriş Yap"),
                    ),
                  ),
                ],
              ),
            ),
            isShowLoading
                ? CustomPositioned(
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/check.riv',
                      fit: BoxFit.cover,
                      onInit: _onCheckRiveInit,
                    ),
                  )
                : const SizedBox(),
            isShowConfetti
                ? CustomPositioned(
                    scale: 6,
                    child: RiveAnimation.asset(
                      "assets/RiveAssets/confetti.riv",
                      onInit: _onConfettiRiveInit,
                      fit: BoxFit.cover,
                    ),
                  )
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
    super.dispose();
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(scale: scale, child: child),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
