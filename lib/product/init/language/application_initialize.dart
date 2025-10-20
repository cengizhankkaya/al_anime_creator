import 'dart:async';
import 'package:al_anime_creator/product/index.dart';
import 'package:al_anime_creator/product/service/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';



@immutable
final class ApplicationInitialize {

  Future<void> make() async {
    await runZonedGuarded<Future<void>>(_initialize, (error, stack){
      Logger().e(error);
      
    });
  }

  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppEnvironment.general();
    await Firebase.initializeApp();
    await setupServiceLocator(); // Dependency injection setup
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableLevels = [LevelMessages.error];
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


    FlutterError.onError = (details) {
      Logger().e(details.exceptionAsString(), stackTrace: details.stack);


    };



  }


  

}