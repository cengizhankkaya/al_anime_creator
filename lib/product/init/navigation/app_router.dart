import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'View,Route')
final class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}