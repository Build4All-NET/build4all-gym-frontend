import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Auth screens
import '../features/auth/presentation/login/screens/login_screen.dart';

// Forgot password screens + BLoC wiring
import '../features/forgotpassword/data/repositories/forgot_password_repository_impl.dart';
import '../features/forgotpassword/data/services/forgot_password_api_service.dart';
import '../features/forgotpassword/domain/usecases/initiate_forgot_password.dart';
import '../features/forgotpassword/domain/usecases/verify_otp_usecase.dart';
import '../features/forgotpassword/domain/usecases/reset_password_usecase.dart';
import '../features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import '../features/forgotpassword/presentation/screens/forgot_password_screen.dart';

class AppRouter {
  // Route name constants — use these everywhere instead of typing strings
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

    // Login screen — Mounir's existing route, unchanged
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

    // Forgot password — YOUR new route
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