import 'package:al_anime_creator/features/data/repository/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_anime_creator/features/presentation/auth/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'features/core/index.dart';
import 'package:al_anime_creator/features/presentation/splash/cubit/splash_cubit.dart';


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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(GetIt.instance<AuthRepository>()),
        ),
        BlocProvider<SplashCubit>(
          create: (_) => SplashCubit(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
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
