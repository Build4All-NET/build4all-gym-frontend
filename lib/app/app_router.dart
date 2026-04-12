import 'package:flutter/material.dart';
import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import '../features/auth/presentation/signup/screens/signup_screen.dart';
import '../features/auth/presentation/signup/screens/otp_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/login/screens/login_screen.dart';
import '../features/forgotpassword/data/repositories/forgot_password_repository_impl.dart';
import '../features/forgotpassword/data/services/forgot_password_api_service.dart';
import '../features/forgotpassword/domain/usecases/initiate_forgot_password.dart';
import '../features/forgotpassword/domain/usecases/verify_otp_usecase.dart';
import '../features/forgotpassword/domain/usecases/reset_password_usecase.dart';
import '../features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import '../features/forgotpassword/presentation/screens/forgot_password_screen.dart';

class AppRouter {
  static const String login  = '/login';
  static const String admin  = '/admin';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';

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

    // Creates the BLoC with all its dependencies wired together
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) {
            // Create the API service (talks to backend)
            final api = ForgotPasswordApiService();

            // Create the repository (bridges API ↔ domain)
            final repo = ForgotPasswordRepositoryImpl(api: api);

            // Wire everything into the BLoC and provide it to Screen 1
            return BlocProvider(
              create: (_) => ForgotPasswordBloc(
                initiateForgotPassword: InitiateForgotPassword(repo),
                verifyOtpUseCase: VerifyOtpUseCase(repo),
                resetPasswordUseCase: ResetPasswordUseCase(repo),
              ),
              child: const ForgotPasswordScreen(),
            );
          },
        );

    // Fallback — route not found
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}