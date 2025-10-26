import 'package:al_anime_creator/features/core/config/app_configuration.dart';
import 'package:al_anime_creator/features/core/config/dev_env.dart';
import 'package:al_anime_creator/features/core/config/prod_env.dart';
import 'package:flutter/foundation.dart';


final class AppEnvironment {
  AppEnvironment.setup({required AppConfiguration config}) {
    _config = config;
  }

  AppEnvironment.general() {
    _config = kDebugMode ? DevEnv() : ProdEnv();
  }

  static late final AppConfiguration _config;
}

enum AppEnvironmentItems {
  baseUrl,

  apiKey;

  String get value {
    try {
      switch (this) {
        case AppEnvironmentItems.baseUrl:
          return AppEnvironment._config.baseUrl;
        case AppEnvironmentItems.apiKey:
          return AppEnvironment._config.apiKey;
      }
    } catch (e) {
      throw Exception('AppEnvironment is not initialized.');
    }
  }
}