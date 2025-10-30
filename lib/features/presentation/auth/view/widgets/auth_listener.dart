import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:al_anime_creator/features/core/config/navigation/app_router.dart';
import 'package:rive/rive.dart';
import 'package:al_anime_creator/features/core/constans/index.dart';
import '../../cubit/auth_cubit.dart';

typedef ShowLoadingSetter = void Function(bool value);

void authListener(
  BuildContext context,
  AuthState state,
  bool isShowLoading,
  ShowLoadingSetter setShowLoading,
  SMITrigger? error,
  SMITrigger? reset,
  VoidCallback? confettiFire,
  ShowLoadingSetter? setShowConfetti,
) {
  if (state is AuthSuccess && isShowLoading) {
    setShowLoading(false);
    // Confetti başlat
    if (setShowConfetti != null) setShowConfetti(true);
    Future.delayed(ProjectDuration.xShort, () {
      confettiFire?.call();
      Future.delayed(ProjectDuration.oneSecond, () {
        if (setShowConfetti != null) setShowConfetti(false);
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        Future.delayed(ProjectDuration.medium, () {
          if (!context.mounted) return;
          context.router.replace(const EntryPointRoute());
        });
      });
    });
  } else if (state is AuthFailure) {
    error?.fire();
    Future.delayed(ProjectDuration.twoSeconds, () {
      setShowLoading(false);
      reset?.fire();
    });
  } else if (state is AuthLoading) {
    setShowLoading(true);
  }
}
