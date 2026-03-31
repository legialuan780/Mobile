import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/app/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sfinity',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.login,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
