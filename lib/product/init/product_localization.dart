


import 'package:al_anime_creator/product/utility/constans/enums/locales.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

@immutable
final class ProductLocalization extends EasyLocalization {
  ProductLocalization({
    required super.child,
    super.key,

  }) : super(supportedLocales:  _supportedLocales,
  path: _translationsPath,
  useOnlyLangCode: true
  );

   static final  List<Locale> _supportedLocales  = [
    Locales.tr.locale,
    Locales.en.locale
  ];

  static const String _translationsPath = 'assets/translations';


  static Future<void> updateLanguage({required BuildContext context, required Locales value}) =>
    context.setLocale(value.locale);
  
 }