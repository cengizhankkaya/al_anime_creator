import 'package:al_anime_creator/feature/feed/feed_view.dart';
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'View,Route')
final class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: FeedRoute.page, initial: true),
  ];
}