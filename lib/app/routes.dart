import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/views/auth/forgot_password_view.dart';
import 'package:Mobile/views/auth/login_view.dart';
import 'package:Mobile/views/auth/register_view.dart';
import 'package:Mobile/views/home/home.dart';
import 'package:flutter/material.dart';

class Routes{
  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      // case RouteNames.forgotPassword:
        // return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return MaterialPageRoute(builder: (_) => const HomeView());
    }
  }
}