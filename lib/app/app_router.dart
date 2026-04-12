import 'package:flutter/material.dart';
import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import '../features/auth/presentation/signup/screens/signup_screen.dart';
import '../features/auth/presentation/signup/screens/otp_screen.dart';

class AppRouter {
  static const String login  = '/login';
  static const String admin  = '/admin';
  static const String signup = '/signup';
  static const String otp = '/otp';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final appConfig = args is AppConfig ? args : AppConfig.fromEnv();

    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => UserLoginScreen(appConfig: appConfig),
        );

      case admin:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Admin Dashboard')),
          ),
        );

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case otp:
      // ✅ Changed to accept Map instead of just String
        final otpArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            contact: otpArgs['contact'] as String,
            email: otpArgs['email'] as String,
            phone: otpArgs['phone'] as String?,
            password: otpArgs['password'] as String,
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