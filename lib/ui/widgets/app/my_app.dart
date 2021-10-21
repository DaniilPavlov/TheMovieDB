import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:themoviedb/Library/Widgets/inherited/provider.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import 'my_app_model.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  // final MyAppModel model;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.read<MyAppModel>(context);
    return MaterialApp(
      title: 'The Movie DB',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor:
                AppColors.mainDarkBlue), // установили в тему значение цвета
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainDarkBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', 'RU'),
      ],
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(model?.isAuth == true),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
