import 'package:flutter/material.dart';
import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import '../features/auth/presentation/signup/screens/signup_screen.dart';
import '../features/auth/presentation/signup/screens/otp_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../features/forgotpassword/data/repositories/forgot_password_repository_impl.dart';
import '../features/forgotpassword/data/services/forgot_password_api_service.dart';
import '../features/forgotpassword/domain/usecases/initiate_forgot_password.dart';
import '../features/forgotpassword/domain/usecases/verify_otp_usecase.dart';
import '../features/forgotpassword/domain/usecases/reset_password_usecase.dart';
import '../features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import '../features/forgotpassword/presentation/screens/forgot_password_screen.dart';

// Admin dashboard imports
import '../features/admin/dashboard/data/services/admin_dashboard_remote_service.dart';
import '../features/admin/dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import '../features/admin/dashboard/domain/usecases/get_admin_dashboard_usecase.dart';
import '../features/admin/dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import '../features/admin/dashboard/presentation/bloc/admin_dashboard_event.dart';
import '../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';

class AppRouter {
  static const String login         = '/login';
  static const String admin         = '/admin';
  static const String signup        = '/signup';
  static const String otp           = '/otp';
  static const String forgotPassword = '/forgot-password';

  static Route onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final appConfig = args is AppConfig ? args : AppConfig.fromEnv();

    switch (settings.name) {

      case login:
        return MaterialPageRoute(
          builder: (_) => UserLoginScreen(appConfig: appConfig),
        );

    // ✅ FIXED — BlocProvider wraps AdminDashboardScreen
    // ✅ FIXED — removed duplicate case admin
      case admin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminDashboardBloc(
              getAdminDashboardUseCase: GetAdminDashboardUseCase(
                repository: AdminDashboardRepositoryImpl(
                  remoteDatasource: AdminDashboardRemoteDatasourceImpl(
                  ),
                ),
              ),
            )..add(const AdminDashboardLoadRequested()),
            child: const AdminDashboardScreen(),
          ),
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );

      case otp:
        final otpArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            contact:  otpArgs['contact'] as String,
            email:    otpArgs['email'] as String,
            phone:    otpArgs['phone'] as String?,
            password: otpArgs['password'] as String,
          ),
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) {
            final api  = ForgotPasswordApiService();
            final repo = ForgotPasswordRepositoryImpl(api: api);
            return BlocProvider(
              create: (_) => ForgotPasswordBloc(
                sendResetCode:   SendResetCode(repo),
                verifyResetCode: VerifyResetCode(repo),
                updatePassword:  UpdatePassword(repo),
              ),
              child: const ForgotPasswordEmailScreen(),
            );
          },
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