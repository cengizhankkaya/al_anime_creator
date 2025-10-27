import 'package:al_anime_creator/features/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:al_anime_creator/features/core/config/navigation/app_router.dart';
import 'package:al_anime_creator/features/presentation/auth/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

/// Authentication durumunu kontrol eden ve kullanıcıyı uygun sayfaya yönlendiren widget
class AuthGuard extends StatelessWidget {
  final Widget child;
  
  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(GetIt.instance<AuthRepository>()),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Kullanıcı giriş yapmış, ana sayfaya yönlendir
            context.router.replace(const EntryPointRoute());
          } else if (state is AuthInitial) {
            // Kullanıcı giriş yapmamış, onboarding'e yönlendir
            context.router.replace(const OnboardingRoute());
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              // Yükleme durumunda loading göster
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            // Diğer durumlarda child widget'ı göster
            return child;
          },
        ),
      ),
    );
  }
}
