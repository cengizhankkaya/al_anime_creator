// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [EntryPoint]
class EntryPointRoute extends PageRouteInfo<void> {
  const EntryPointRoute({List<PageRouteInfo>? children})
    : super(EntryPointRoute.name, initialChildren: children);

  static const String name = 'EntryPointRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EntryPoint();
    },
  );
}

/// generated route for
/// [FavoritesView]
class FavoritesRoute extends PageRouteInfo<void> {
  const FavoritesRoute({List<PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesView();
    },
  );
}

/// generated route for
/// [ProfileView]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileView();
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
/// [StoryHistoryViewWrapper]
class StoryHistoryRoute extends PageRouteInfo<StoryHistoryRouteArgs> {
  StoryHistoryRoute({Key? key, String? storyId, List<PageRouteInfo>? children})
    : super(
        StoryHistoryRoute.name,
        args: StoryHistoryRouteArgs(key: key, storyId: storyId),
        initialChildren: children,
      );

  static const String name = 'StoryHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StoryHistoryRouteArgs>(
        orElse: () => const StoryHistoryRouteArgs(),
      );
      return StoryHistoryViewWrapper(key: args.key, storyId: args.storyId);
    },
  );
}

class StoryHistoryRouteArgs {
  const StoryHistoryRouteArgs({this.key, this.storyId});

  final Key? key;

  final String? storyId;

  @override
  String toString() {
    return 'StoryHistoryRouteArgs{key: $key, storyId: $storyId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StoryHistoryRouteArgs) return false;
    return key == other.key && storyId == other.storyId;
  }

  @override
  int get hashCode => key.hashCode ^ storyId.hashCode;
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

/// generated route for
/// [ReaderPage]
class ReaderRoute extends PageRouteInfo<void> {
  const ReaderRoute({List<PageRouteInfo>? children})
    : super(ReaderRoute.name, initialChildren: children);

  static const String name = 'ReaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      // Note: ReaderPage requires args; you may navigate with a custom route push providing widget directly
      // or extend to typed args if desired.
      return const SizedBox.shrink();
    },
  );
}
