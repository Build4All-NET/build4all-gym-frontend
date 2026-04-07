import 'package:flutter/material.dart';

// auth screens
import '../features/auth/presentation/login/screens/login_screen.dart';
import '../features/auth/presentation/signup/screens/signup_screen.dart';
import '../features/auth/presentation/otp/screens/otp_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case otp:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(email: email),
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