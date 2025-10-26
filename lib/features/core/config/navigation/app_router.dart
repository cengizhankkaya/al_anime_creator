import 'package:al_anime_creator/features/presentation/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/entry_point.dart';
import 'package:al_anime_creator/features/presentation/onboarding/view/onboarding_view.dart';
import 'package:al_anime_creator/features/presentation/splash/view/splash_view.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/story_generation_view.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/story_history_view.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/favorites_view.dart';
import 'package:al_anime_creator/features/presentation/help/help_view.dart';
import 'package:auto_route/auto_route.dart';

// TODO: Rota vermek istediğiniz sayfaları (View) buraya import edin.
// Örnek:
// import 'package:al_anime_creator/features/splash/view/splash_view.dart';
// import 'package:al_anime_creator/features/home/view/home_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: EntryPointRoute.page),
        AutoRoute(page: StoryGenerationRoute.page),
        AutoRoute(page: StoryHistoryRoute.page, path: '/story-history'),
        AutoRoute(page: FavoritesRoute.page, path: '/favorites'),
        AutoRoute(page: HelpRoute.page, path: '/help'),
        AutoRoute(page: ProfileRoute.page, path: '/profile'),
      ];
}