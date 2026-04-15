import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../controllers/settings_controller.dart';
import '../utils/app_language.dart';
import '../utils/app_styles.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Sfinity',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppStyles.primaryColor,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppStyles.primaryColor,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: settingsController.themeMode,
          locale: settingsController.locale,
          localizationsDelegates: const [
            AppLangugeDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('vi', ''),
          ],
          initialRoute: RouteNames.login,
          onGenerateRoute: Routes.onGenerateRoute,
        );
      },
    );
  }
}
