import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/auth/cubit/auth_cubit.dart';


import 'widgets/dialog_container.dart';

void showCustomDialog(BuildContext context, {required ValueChanged onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: AppColors.of(context).blackd.withValues(alpha: 0.5),
    transitionDuration: ProjectDuration.longMs,
    pageBuilder: (context, animation, secondaryAnimation) {
      return BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(AuthRepository()),
        child: Center(
          child: DialogContainer(),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  ).then(onValue);
}
