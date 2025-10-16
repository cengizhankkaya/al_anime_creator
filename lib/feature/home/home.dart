


import 'package:al_anime_creator/product/init/product_localization.dart';
import 'package:al_anime_creator/product/init/language/locale_keys.g.dart';
import 'package:al_anime_creator/product/utility/constans/enums/locales.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text('Change language'),
          ElevatedButton(onPressed: () {
            ProductLocalization.updateLanguage(context: context, value: Locales.en);
          } ,
          child:  Text(LocaleKeys.general_button_save.tr())
          ),
        ],
      ),

    );
  }
}