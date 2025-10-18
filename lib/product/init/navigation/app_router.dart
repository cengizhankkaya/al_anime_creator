import 'package:al_anime_creator/features/home/home_screen.dart';
import 'package:al_anime_creator/features/onboding/onboding_screen.dart';
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
        AutoRoute(page: HomeView.page),
      ];
}