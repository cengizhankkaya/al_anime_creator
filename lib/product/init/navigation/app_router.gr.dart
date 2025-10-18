// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [HomePage]
class HomeView extends PageRouteInfo<void> {
  const HomeView({List<PageRouteInfo>? children})
    : super(HomeView.name, initialChildren: children);

  static const String name = 'HomeView';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [StoryGenerationView]
class StoryGenerationRoute extends PageRouteInfo<void> {
  const StoryGenerationRoute({List<PageRouteInfo>? children})
    : super(StoryGenerationRoute.name, initialChildren: children);

  static const String name = 'StoryGenerationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StoryGenerationView();
    },
  );
}

/// generated route for
/// [StoryHistoryView]
class StoryHistoryRoute extends PageRouteInfo<void> {
  const StoryHistoryRoute({List<PageRouteInfo>? children})
    : super(StoryHistoryRoute.name, initialChildren: children);

  static const String name = 'StoryHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StoryHistoryView();
    },
  );
}

/// generated route for
/// [onboardingView]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const onboardingView();
    },
  );
}
