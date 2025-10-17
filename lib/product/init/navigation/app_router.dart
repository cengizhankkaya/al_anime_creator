import 'package:al_anime_creator/features/demo/demo_view.dart';
import 'package:al_anime_creator/features/feed/view/feed_view.dart';
import 'package:al_anime_creator/features/home/home_view.dart';
import 'package:al_anime_creator/features/profile/profile_view.dart';
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'View,Route')
final class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}