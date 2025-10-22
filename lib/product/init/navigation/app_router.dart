import 'package:al_anime_creator/features/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/entryPoint/entry_point.dart';
import 'package:al_anime_creator/features/onboarding/view/onboarding_view.dart';
import 'package:al_anime_creator/features/storygeneration/view/story_generation_view.dart';
import 'package:al_anime_creator/features/storyhistory/view/story_history_view.dart';
import 'package:al_anime_creator/features/storyhistory/view/favorites_view.dart';
import 'package:al_anime_creator/features/help/help_view.dart';
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
        AutoRoute(page: OnboardingRoute.page, initial: true),
        AutoRoute(page: EntryPointRoute.page),
        AutoRoute(page: StoryGenerationRoute.page),
        AutoRoute(page: StoryHistoryRoute.page, path: '/story-history'),
        AutoRoute(page: FavoritesRoute.page, path: '/favorites'),
        AutoRoute(page: HelpRoute.page, path: '/help'),
      ];
}