import 'package:flutter/material.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';

class AppRouter {
  static const String login  = '/login';
  static const String admin  = '/admin';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // arguments بتيجي من Navigator.pushNamed(..., arguments: appConfig)
    final args = settings.arguments;
    final appConfig = args is AppConfig ? args : AppConfig.fromEnv();

    switch (settings.name) {

      case login:
        return MaterialPageRoute(
          builder: (_) => UserLoginScreen(appConfig: appConfig),
        );

      case admin:
      // TODO: استبدلها بشاشة الأدمن الحقيقية
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Admin Dashboard')),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}