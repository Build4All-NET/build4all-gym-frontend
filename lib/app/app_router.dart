import 'package:build4allgym/features/member/home/domain/usecases/log_weight_usecase.dart';
import 'package:flutter/material.dart';
import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import '../features/admin/plans/data/repositories/admin_plans_repository_impl.dart';
import '../features/admin/plans/data/services/admin_plans_remote_service.dart';
import '../features/admin/plans/domain/usecases/admin_plans_usecases.dart';
import '../features/admin/plans/presentation/bloc/admin_plans/admin_plans_bloc.dart';
import '../features/admin/plans/presentation/screens/admin_plans_screen.dart';
import '../features/auth/data/services/auth_token_store.dart';
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

import '../features/shell/presentation/screens/main_shell.dart';

// USER main screen imports
import '../features/member/home/presentation/bloc/member_home_bloc.dart';
import '../features/member/home/presentation/screens/member_home_screen.dart';
import '../features/member/home/data/repositories/member_home_repository_impl.dart';
import '../features/member/home/domain/usecases/get_member_home_usecase.dart';
import '../features/member/home/presentation/bloc/member_home_event.dart';
import '../features/member/home/data/services/member_home_remote_datasource.dart';

// TODO: Uncomment each import as teammates finish their screens:
// import '../features/admin/members/presentation/screens/admin_members_screen.dart';
// import '../features/admin/trainers/presentation/screens/admin_trainers_screen.dart';
// import '../features/admin/staff/presentation/screens/admin_staff_screen.dart';
// import '../features/admin/gym_profile/presentation/screens/admin_gym_profile_screen.dart';
// import '../features/admin/branches/presentation/screens/admin_branches_screen.dart';
// import '../features/admin/checkins/presentation/screens/admin_checkins_screen.dart';
// import '../features/admin/payments/presentation/screens/admin_payments_screen.dart';
// import '../features/admin/classes/presentation/screens/admin_classes_screen.dart';
// import '../features/admin/notifications/presentation/screens/admin_notifications_screen.dart';
// import '../features/admin/pt_sessions/presentation/screens/admin_pt_sessions_screen.dart';
// import '../features/admin/training_videos/presentation/screens/admin_training_videos_screen.dart';
// import '../features/admin/settings/presentation/screens/admin_settings_screen.dart';

class AppRouter {
  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String login          = '/login';
  static const String signup         = '/signup';
  static const String otp            = '/otp';
  static const String forgotPassword = '/forgot-password';

  // ─── Role roots ────────────────────────────────────────────────────────────
  static const String admin          = '/admin';   // legacy root → dashboard
  static const String user           = '/user';

  // ─── Admin: Core Owner ─────────────────────────────────────────────────────
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMembers   = '/admin/members';
  static const String adminPlans     = '/admin/plans';
  static const String adminTrainers  = '/admin/trainers';
  static const String adminStaff     = '/admin/staff';
  static const String adminGymProfile= '/admin/gym-profile';
  static const String adminBranches  = '/admin/branches';

  // ─── Admin: Operations / Reception ────────────────────────────────────────
  static const String adminCheckins      = '/admin/checkins';
  static const String adminPayments      = '/admin/payments';
  static const String adminClasses       = '/admin/classes';
  static const String adminNotifications = '/admin/notifications';

  // ─── Admin: Training / PT ─────────────────────────────────────────────────
  static const String adminPtSessions      = '/admin/pt-sessions';
  static const String adminTrainingVideos  = '/admin/training-videos';

  // ─── Admin: Settings ──────────────────────────────────────────────────────
  static const String adminSettings = '/admin/settings';

  // ─── Logout ────────────────────────────────────────────────────────────────
  static const String logout = '/logout';

  // ──────────────────────────────────────────────────────────────────────────

  static Route onGenerateRoute(RouteSettings settings) {
    final args      = settings.arguments;
    final appConfig = args is AppConfig ? args : AppConfig.fromEnv();

    switch (settings.name) {

    // ── Auth ───────────────────────────────────────────────────────────────

      case login:
        return MaterialPageRoute(
          builder: (_) => UserLoginScreen(appConfig: appConfig),
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
            email:    otpArgs['email']   as String,
            phone:    otpArgs['phone']   as String?,
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

    // ── Member shell ───────────────────────────────────────────────────────

      case user:
        return MaterialPageRoute(
          builder: (_) => MainShell(appConfig: appConfig),
        );

    // ── Admin: Dashboard (both legacy /admin and new /admin/dashboard) ─────

      case admin:
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminDashboardBloc(
              getAdminDashboardUseCase: GetAdminDashboardUseCase(
                repository: AdminDashboardRepositoryImpl(
                  remoteDatasource: AdminDashboardRemoteDatasourceImpl(),
                ),
              ),
            )..add(const AdminDashboardLoadRequested()),
            child: const AdminDashboardScreen(),
          ),
        );

    // ── Admin: Plans (already built) ───────────────────────────────────────

      case adminPlans:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminPlansBloc(
              getStats: GetAdminPlanStatsUseCase(
                repository: AdminPlansRepositoryImpl(
                  remoteDatasource: AdminPlansRemoteDatasourceImpl(),
                ),
              ),
              getPlans: GetAdminPlansUseCase(
                repository: AdminPlansRepositoryImpl(
                  remoteDatasource: AdminPlansRemoteDatasourceImpl(),
                ),
              ),
              getPlanTypes: GetPlanTypesUseCase(
                repository: AdminPlansRepositoryImpl(
                  remoteDatasource: AdminPlansRemoteDatasourceImpl(),
                ),
              ),
              deletePlan: DeletePlanUseCase(
                repository: AdminPlansRepositoryImpl(
                  remoteDatasource: AdminPlansRemoteDatasourceImpl(),
                ),
              ),
            )..add(LoadAdminPlansEvent()),
            child: const AdminPlansScreen(),
          ),
        );

    // ── Admin: Members ─────────────────────────────────────────────────────
    // TODO: Replace _ComingSoonScreen with AdminMembersScreen once built.
    // import '../features/admin/members/presentation/screens/admin_members_screen.dart';
      case adminMembers:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Members'),
        );

    // ── Admin: Trainers / PT ───────────────────────────────────────────────
    // TODO: Replace with AdminTrainersScreen once built.
      case adminTrainers:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Trainers / PT'),
        );

    // ── Admin: Reception Staff ─────────────────────────────────────────────
    // TODO: Replace with AdminStaffScreen once built.
      case adminStaff:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Reception Staff'),
        );

    // ── Admin: Gym Profile ─────────────────────────────────────────────────
    // TODO: Replace with AdminGymProfileScreen once built.
      case adminGymProfile:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Gym Profile'),
        );

    // ── Admin: Branches ────────────────────────────────────────────────────
    // TODO: Replace with AdminBranchesScreen once built.
      case adminBranches:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Branches'),
        );

    // ── Admin: Check-ins ───────────────────────────────────────────────────
    // TODO: Replace with AdminCheckinsScreen once built.
      case adminCheckins:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Check-ins'),
        );

    // ── Admin: Payments ────────────────────────────────────────────────────
    // TODO: Replace with AdminPaymentsScreen once built.
      case adminPayments:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Payments'),
        );

    // ── Admin: Classes & PT ────────────────────────────────────────────────
    // TODO: Replace with AdminClassesScreen once built.
      case adminClasses:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Classes & PT'),
        );

    // ── Admin: Notifications ───────────────────────────────────────────────
    // TODO: Replace with AdminNotificationsScreen once built.
      case adminNotifications:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Notifications'),
        );

    // ── Admin: PT Sessions ─────────────────────────────────────────────────
    // TODO: Replace with AdminPtSessionsScreen once built.
      case adminPtSessions:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'PT Sessions'),
        );

    // ── Admin: Training Videos ─────────────────────────────────────────────
    // TODO: Replace with AdminTrainingVideosScreen once built.
      case adminTrainingVideos:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Training Videos'),
        );

    // ── Admin: Settings ────────────────────────────────────────────────────
    // TODO: Replace with AdminSettingsScreen once built.
      case adminSettings:
        return MaterialPageRoute(
          builder: (_) => const _ComingSoonScreen(title: 'Settings'),
        );

    // ── Logout ────────────────────────────────────────────────────────────
    // The drawer handles logout via a confirm dialog and pushes /login directly.
    // This case is a safety fallback if /logout is ever pushed programmatically.
      case logout:
        return MaterialPageRoute(
          builder: (_) => UserLoginScreen(appConfig: appConfig),
        );

    // ── 404 fallback ───────────────────────────────────────────────────────
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

// ─── Stub screen ─────────────────────────────────────────────────────────────
/// Temporary placeholder shown for screens not yet implemented.
/// Replaced screen-by-screen as teammates deliver their work.
/// Shows the screen name so navigation is visually testable immediately.
class _ComingSoonScreen extends StatelessWidget {
  final String title;

  const _ComingSoonScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}