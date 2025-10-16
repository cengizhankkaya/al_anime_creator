
import 'package:al_anime_creator/product/init/config/app_configuration.dart';

final class AppEnviroment {
  AppEnviroment.setup({required AppConfiguration config}) {
    _config = config;
  }

  static late final AppConfiguration _config;

  static String get baseUrl => _config.baseUrl;

  static String get apiKey => _config.apiKey;
}

