import 'package:event_finder/views/auth/login_page.dart';
import 'package:event_finder/views/auth/pre_auth_page.dart';
import 'package:event_finder/views/auth/register_page.dart';
import 'package:event_finder/views/home_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PreAuthPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                          'Diese Route existiert nicht: ${settings.name}')),
                ));
    }
  }
}
