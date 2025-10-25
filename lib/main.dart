import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/auth/cubit/auth_cubit.dart';
import 'package:al_anime_creator/features/auth/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'product/init/index.dart';



Future<void> main() async {
  await ApplicationInitialize().make();
  runApp(ProductLocalization(child: const MyApp()));
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(GetIt.instance<AuthRepository>()),
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        theme: CustomLightTheme().themeData,
        darkTheme: CustomDarkTheme().themeData,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
