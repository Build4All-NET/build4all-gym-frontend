import 'package:build4allgym/features/admin/members/presentation/bloc/admin_members_bloc.dart';
import 'package:build4allgym/features/admin/pt_dashboard/data/services/pt_package_service.dart';
import 'package:build4allgym/features/admin/staff/data/repositories/gym_reception_repository_impl.dart';
import 'package:build4allgym/features/admin/staff/data/services/gym_reception_service.dart';
import 'package:build4allgym/features/admin/staff/presentation/screens/admin_gym_reception_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import '../core/network/globals.dart';
import '../features/admin/AppBar/presentation/branch_cubit.dart';
import '../features/admin/ai_assistant/data/repositories/ai_assistant_repository_impl.dart';
import '../features/admin/ai_assistant/data/services/ai_assistant_remote_service.dart';
import '../features/admin/ai_assistant/domain/usecases/get_recent_queries_usecase.dart';
import '../features/admin/ai_assistant/domain/usecases/get_suggested_questions_usecase.dart';
import '../features/admin/ai_assistant/domain/usecases/send_ai_query_usecase.dart';
import '../features/admin/ai_assistant/presentation/bloc/ai_assistant_bloc.dart';
import '../features/admin/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import '../features/admin/branches/presentation/bloc/branches_event.dart';
import '../features/admin/branches/presentation/screens/branches_list_page.dart';
import '../features/admin/checkins/data/services/CheckinsRemoteDataSource.dart';
import '../features/admin/classes/data/repositories/admin_classes_repository_impl.dart';
import '../features/admin/classes/data/services/admin_classes_service.dart';
import '../features/admin/classes/domain/usecases/cancel_class_usecase.dart';
import '../features/admin/classes/domain/usecases/create_class_usecase.dart';
import '../features/admin/classes/domain/usecases/get_class_form_options_usecase.dart';
import '../features/admin/classes/domain/usecases/get_classes_by_date_usecase.dart';
import '../features/admin/classes/domain/usecases/confirm_booking_payment_usecase.dart';
import '../features/admin/classes/domain/usecases/reject_booking_usecase.dart';
import '../features/admin/classes/domain/usecases/get_session_bookings_usecase.dart';
import '../features/admin/classes/domain/usecases/reactivate_class_usecase.dart';
import '../features/admin/classes/domain/usecases/update_class_usecase.dart';
import '../features/admin/classes/domain/usecases/approve_cancellation_usecase.dart';
import '../features/admin/classes/domain/usecases/decline_cancellation_usecase.dart';
import '../features/admin/classes/presentation/bloc/admin_classes_bloc.dart';
import '../features/admin/classes/presentation/bloc/admin_classes_event.dart';
import '../features/admin/classes/presentation/screens/admin_classes_screen.dart';
import '../features/admin/members/data/services/admin_members_service.dart';
import '../features/admin/members/domain/usecases/block_member_use_case.dart' as member_uc;
import '../features/admin/members/domain/usecases/bulk_delete_members_use_case.dart';
import '../features/admin/members/domain/usecases/delete_member_use_case.dart';
import '../features/admin/members/domain/usecases/get_member_attendance_use_case.dart';
import '../features/admin/members/domain/usecases/get_member_detail_use_case.dart';
import '../features/admin/members/domain/usecases/get_members_use_case.dart';
import '../features/admin/members/domain/usecases/unblock_member_use_case.dart';
import '../features/admin/members/presentation/screens/member_detail_screen.dart';
import '../features/admin/plans/data/repositories/admin_plans_repository_impl.dart';
import '../features/admin/plans/data/services/admin_plans_remote_service.dart';
import '../features/admin/plans/domain/usecases/admin_plans_usecases.dart' hide GetBranchesUseCase;
import '../features/admin/plans/presentation/bloc/admin_plans/admin_plans_bloc.dart';
import '../features/admin/plans/presentation/screens/admin_plans_screen.dart';
import '../features/admin/pt_dashboard/data/repositories/trainer_pt_sessions_repository_impl.dart';
import '../features/admin/pt_dashboard/data/services/availability_service.dart';
import '../features/admin/pt_dashboard/data/services/pt_service_service.dart';
import '../features/admin/pt_dashboard/data/services/trainer_pt_sessions_service.dart';
import '../features/admin/pt_dashboard/domain/usecases/trainer_pt_sessions_usecases.dart';
import '../features/admin/staff/domain/usecases/gym_reception_usecases.dart';
import '../features/admin/staff/presentation/bloc/gym_reception_cubit.dart';
import '../features/admin/staff/domain/usecases/create_staff_usecase.dart';
import '../features/admin/staff/domain/usecases/get_staff_usecase.dart';
import '../features/admin/staff/domain/usecases/remove_staff_usecase.dart';
import '../features/admin/staff/presentation/bloc/admin_staff_bloc.dart';
import '../features/admin/trainers/data/repositories/GymTrainersRepositoryImpl.dart';
import '../features/admin/trainers/data/services/GymTrainersService.dart';
import '../features/admin/trainers/domain/usecases/GetGymTrainersUseCase.dart';
import '../features/admin/trainers/domain/usecases/get_trainer_detail_usecase.dart';
import '../features/admin/trainers/presentation/bloc/GymTrainersCubit.dart';
import '../features/admin/trainers/presentation/bloc/admin_trainers_event.dart';
import '../features/admin/training_videos/data/repositories/training_video_repository_impl.dart';
import '../features/admin/training_videos/data/services/training_video_remote_datasource.dart';
import '../features/admin/training_videos/domain/usecases/CreateCategoryUseCase.dart';
import '../features/admin/training_videos/presentation/bloc/training_videos_bloc.dart';
import '../features/admin/training_videos/presentation/bloc/training_videos_event.dart';
import '../features/admin/training_videos/presentation/screens/training_videos_list_page.dart';
import '../features/auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../features/auth/presentation/signup/screens/signup_screen.dart';
import '../features/auth/presentation/signup/screens/otp_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/forgotpassword/data/repositories/forgot_password_repository_impl.dart';
import '../features/forgotpassword/data/services/forgot_password_api_service.dart';
import '../features/forgotpassword/domain/usecases/initiate_forgot_password.dart';
import '../features/forgotpassword/domain/usecases/verify_otp_usecase.dart';
import '../features/forgotpassword/domain/usecases/reset_password_usecase.dart';
import '../features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import '../features/forgotpassword/presentation/screens/forgot_password_screen.dart';

import '../features/admin/dashboard/data/services/admin_dashboard_remote_service.dart';
import '../features/admin/dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import '../features/admin/dashboard/domain/usecases/get_admin_dashboard_usecase.dart';
import '../features/admin/dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import '../features/admin/dashboard/presentation/bloc/admin_dashboard_event.dart';
import '../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';

import '../features/gym_profile/presentation/screens/role_check_screen.dart';
import '../features/shell/presentation/screens/main_shell.dart';
import '../features/admin/pt_dashboard/presentation/screens/trainer_main_screen.dart';
import '../features/admin/pt_dashboard/presentation/screens/admin_pt_package_bookings_screen.dart';

import '../features/member/home/presentation/bloc/member_home_bloc.dart';
import '../features/member/home/presentation/screens/member_home_screen.dart';
import '../features/member/home/data/repositories/member_home_repository_impl.dart';
import '../features/member/home/domain/usecases/get_member_home_usecase.dart';
import '../features/member/home/presentation/bloc/member_home_event.dart';
import '../features/member/home/data/services/member_home_remote_datasource.dart';

import '../features/admin/members/presentation/screens/admin_members_screen.dart';
import '../features/admin/members/data/repositories/admin_members_repository_impl.dart';

import '../features/admin/trainers/data/services/admin_trainers_service.dart';
import '../features/admin/trainers/data/repositories/admin_trainers_repository_impl.dart';
import '../features/admin/trainers/domain/usecases/get_trainers_usecase.dart';
import '../features/admin/trainers/domain/usecases/get_trainer_form_options_usecase.dart';
import '../features/admin/trainers/domain/usecases/create_trainer_usecase.dart';
import '../features/admin/trainers/domain/usecases/update_trainer_usecase.dart';
import '../features/admin/trainers/domain/usecases/block_trainer_usecase.dart';
import '../features/admin/trainers/presentation/bloc/admin_trainers_bloc.dart';
import '../features/admin/trainers/presentation/screens/admin_trainers_screen.dart';


// ── Branches imports ──────────────────────────────────────────────────────────
import '../features/admin/branches/data/repository/branch_repository_impl.dart';
import '../features/admin/branches/domain/usecase/get_branches_usecase.dart';
import '../features/admin/branches/domain/usecase/get_branch_detail_usecase.dart';
import '../features/admin/branches/domain/usecase/create_branch_usecase.dart';
import '../features/admin/branches/domain/usecase/update_branch_usecase.dart';
import '../features/admin/branches/domain/usecase/delete_branch_usecase.dart';
import '../features/admin/branches/presentation/bloc/branches_bloc.dart';

// ── Training Videos imports ───────────────────────────────────────────────────
import '../features/admin/training_videos/domain/usecases/get_training_videos_usecase.dart';
import '../features/admin/training_videos/domain/usecases/get_video_categories_usecase.dart';
import '../features/admin/training_videos/domain/usecases/create_training_video_use_case.dart';
import '../features/admin/training_videos/domain/usecases/update_training_video_usecase.dart';
import '../features/admin/training_videos/domain/usecases/delete_video_usecase.dart';
import '../features/admin/training_videos/domain/usecases/GetTrainersUseCase.dart';

// ── Admin Settings imports ───────────────────────────────────────────────────
import '../features/admin/settings/data/repositories/admin_settings_repository_impl.dart';
import '../features/admin/settings/data/services/admin_settings_remote_service.dart';
import '../features/admin/settings/domain/usecases/get_admin_settings_usecase.dart';
import '../features/admin/settings/presentation/cubit/admin_settings_cubit.dart';
import '../features/admin/settings/presentation/screens/admin_settings_screen.dart';

// ── Member Settings imports ──────────────────────────────────────────────────
import '../features/member/settings/data/repositories/member_settings_repository_impl.dart';
import '../features/member/settings/data/services/member_settings_remote_service.dart';
import '../features/member/settings/domain/usecases/get_member_settings_usecase.dart';
import '../features/member/settings/presentation/cubit/member_settings_cubit.dart';
import '../features/member/settings/presentation/screens/member_settings_screen.dart';

import '../features/admin/checkins/data/repositories/checkins_repository_impl.dart';
import '../features/admin/checkins/domain/usecases/checkins_usecases.dart';
import '../features/admin/checkins/presentation/bloc/checkins_bloc.dart';
import '../features/admin/checkins/presentation/screens/checkins_screen.dart';
import '../features/admin/payment_config/data/services/admin_payment_config_service.dart';
import '../features/admin/payment_config/presentation/cubit/admin_payment_config_cubit.dart';
import '../features/admin/payment_config/presentation/screens/admin_payment_config_screen.dart';
import '../features/admin/membership_requests/data/services/admin_membership_requests_service.dart';
import '../features/admin/membership_requests/data/repositories/admin_membership_requests_repository_impl.dart';
import '../features/admin/membership_requests/domain/usecases/membership_requests_usecases.dart';
import '../features/admin/membership_requests/presentation/bloc/admin_membership_requests_bloc.dart';
import '../features/admin/membership_requests/presentation/screens/admin_membership_requests_screen.dart';
import '../features/admin/invoices/data/repositories/admin_invoice_repository_impl.dart';
import '../features/admin/invoices/data/services/admin_invoice_service.dart';
import '../features/admin/invoices/domain/usecases/admin_invoice_usecases.dart';
import '../features/admin/invoices/presentation/bloc/admin_invoice_bloc.dart';
import '../features/admin/invoices/presentation/bloc/admin_invoices_list_bloc.dart';
import '../features/admin/invoices/presentation/screens/admin_invoice_screen.dart';
import '../features/admin/invoices/presentation/screens/admin_invoices_list_screen.dart';
import '../features/member/invoices/data/repositories/member_invoice_repository_impl.dart';
import '../features/member/invoices/data/services/member_invoice_service.dart';
import '../features/member/invoices/domain/usecases/member_invoice_usecases.dart';
import '../features/member/invoices/presentation/bloc/member_invoice_bloc.dart';
import '../features/member/invoices/presentation/bloc/member_invoices_list_bloc.dart';
import '../features/member/invoices/presentation/screens/member_invoice_screen.dart';
import '../features/member/invoices/presentation/screens/member_invoices_list_screen.dart';
class AppRouter {
  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String login          = '/login';
  static const String signup         = '/signup';
  static const String otp            = '/otp';
  static const String forgotPassword = '/forgot-password';

  // ─── Role roots ────────────────────────────────────────────────────────────
  static const String admin = '/admin';
  static const String user  = '/user';
  static const String roleCheck = '/role-check';

  // ─── Admin: Core Owner ─────────────────────────────────────────────────────
  static const String adminDashboard  = '/admin/dashboard';
  static const String adminMembers    = '/admin/members';
  static const String memberDetail    = '/admin/members/detail';
  static const String adminPlans      = '/admin/plans';
  static const String adminTrainers   = '/admin/trainers';
  static const String adminStaff      = '/admin/staff';
  static const String adminAiAssistant = '/admin/ai_assistant';
  static const String adminBranches   = '/admin/branches';

  // ─── Admin: Operations / Reception ────────────────────────────────────────
  static const String adminCheckins      = '/admin/checkins';
  static const String adminPayments      = '/admin/payments';
  static const String adminClasses       = '/admin/classes';
  static const String adminNotifications = '/admin/notifications';

  // ─── Admin: Training / PT ─────────────────────────────────────────────────
  static const String adminPtSessions            = '/admin/pt-services';
  static const String adminPtPackageBookings     = '/admin/pt-package-bookings';
  static const String adminTrainingVideos        = '/admin/training-videos';

  // ─── Admin: Settings ──────────────────────────────────────────────────────
  static const String adminMembershipRequests = '/admin/membership-requests';
  static const String adminSettings = '/admin/settings';
  static const String userSettings = '/user/settings';

  // ─── Member: Invoices ─────────────────────────────────────────────────────
  static const String memberInvoices = '/member/invoices';
  static const String memberInvoiceDetail = '/member/invoices/detail';

  // ─── Logout ────────────────────────────────────────────────────────────────
  static const String logout = '/logout';

  // ─── Profile wrapper ───────────────────────────────────────────────────────
  // Injects AdminProfileCubit above every admin screen.
  // Every admin case uses this so the cubit is always available in the tree.
  static Widget _withProfile(Widget child) => BlocProvider(
    create: (_) => AdminProfileCubit(),
    child: child,
  );

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
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case otp:
        final otpArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            contact:  otpArgs['contact']  as String,
            email:    otpArgs['email']    as String,
            phone:    otpArgs['phone']    as String?,
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

    // ── Role Check (post-login bridge) ─────────────────────────────────────────
      case roleCheck:
        return MaterialPageRoute(
          builder: (_) => const RoleCheckScreen(),
        );

    // ── Member shell ───────────────────────────────────────────────────────

      case user:
        return MaterialPageRoute(
          builder: (_) => MainShell(appConfig: appConfig),
        );




    // ── User: Settings ────────────────────────────────────────────────────
      case userSettings:
        final repo = MemberSettingsRepositoryImpl(
          MemberSettingsRemoteService(),
        );

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MemberSettingsCubit(
              getSettings: GetMemberSettingsUseCase(repo),
              saveSettings: UpdateMemberSettingsUseCase(repo),
            ),
            child: const MemberSettingsScreen(),
          ),
        );

    // ── Member: Invoices list ───────────────────────────────────────────────

      case memberInvoices:
        final invoiceRepo = MemberInvoiceRepositoryImpl(
          MemberInvoiceService(appDio ?? Dio()),
        );

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MemberInvoicesListBloc(
              listInvoicesUseCase: ListMemberInvoicesUseCase(invoiceRepo),
              requestRefundUseCase: RequestMemberRefundUseCase(invoiceRepo),
            ),
            child: const MemberInvoicesListScreen(),
          ),
        );
// ── Member: Invoice detail ──────────────────────────────────────────────

      case memberInvoiceDetail:
        final invoiceId = settings.arguments as int;

        final invoiceRepo = MemberInvoiceRepositoryImpl(
          MemberInvoiceService(appDio ?? Dio()),
        );

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MemberInvoiceBloc(
              getInvoiceUseCase: GetMemberInvoiceUseCase(invoiceRepo),
            ),
            child: MemberInvoiceScreen(invoiceId: invoiceId),
          ),
        );
    // ── Admin: Dashboard ───────────────────────────────────────────────────

      case admin:
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => BranchCubit()..loadBranches(),
                ),
                BlocProvider(
                  create: (_) => AdminDashboardBloc(
                    getAdminDashboardUseCase: GetAdminDashboardUseCase(
                      repository: AdminDashboardRepositoryImpl(
                        remoteDatasource:
                        AdminDashboardRemoteDatasourceImpl(),
                      ),
                    ),
                  )..add(const AdminDashboardLoadRequested()),
                ),
              ],
              child: AdminDashboardScreen(), // replace with your screen
            ),
          ),
        );

    // ── Admin: Plans ───────────────────────────────────────────────────────

      case adminPlans:
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BranchCubit()..loadBranches()),
                BlocProvider(
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
                ),
              ],
              child: const AdminPlansScreen(),
            ),
          ),
        );

    // ── Admin: Members ─────────────────────────────────────────────────────

      case adminMembers:
        final mArgs      = settings.arguments as Map<String, dynamic>?;
        final branchId   = mArgs?['branchId']   as int?    ?? 1;
        final branchName = mArgs?['branchName'] as String? ?? 'Main Branch';
        final address    = mArgs?['address']    as String? ?? '';

        final service    = AdminMembersService();
        final repository = AdminMembersRepositoryImpl(service: service);

        return MaterialPageRoute(
          builder: (_) => _withProfile(
            AdminMembersPage(
              branchId:   branchId,
              branchName: branchName,
              address:    address,
              bloc: AdminMembersBloc(
                branchId:                  branchId,
                getMembersUseCase:         GetMembersUseCase(repository),
                getMemberDetailUseCase:    GetMemberDetailUseCase(repository),
                getMemberAttendanceUseCase: GetMemberAttendanceUseCase(repository),
                blockMemberUseCase: member_uc.BlockMemberUseCase(repository),
                unblockMemberUseCase:      UnblockMemberUseCase(repository),
                deleteMemberUseCase:       DeleteMemberUseCase(repository),
                bulkDeleteMembersUseCase:  BulkDeleteMembersUseCase(repository),
              ),
            ),
          ),
        );

    // ── Admin: Member Detail ───────────────────────────────────────────────

      case memberDetail:
        final dArgs  = settings.arguments as Map<String, dynamic>;
        final userId = dArgs['userId'] as int;
        final bloc   = dArgs['bloc']   as AdminMembersBloc;
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            BlocProvider.value(
              value: bloc,
              child: MemberDetailPage(userId: userId),
            ),
          ),
        );

    // ── Admin: Trainers ────────────────────────────────────────────────────

      case adminTrainers:
        final gymTrainersRepo = GymTrainersRepositoryImpl(GymTrainersService());
        return MaterialPageRoute(
          builder: (_) => _withProfile(
    MultiBlocProvider(
    providers: [
    BlocProvider
      (create: (_) => BranchCubit()..loadBranches()),
            BlocProvider(
              create: (_) => GymTrainersCubit(
                getTrainers:    GetGymTrainersUseCase(gymTrainersRepo),
                removeTrainer:  RemoveGymTrainerUseCase(gymTrainersRepo),
              )..load(),
            )
              ],  child: const AdminGymTrainersScreen(),
    ),
          ),
        );

    // ── Admin: Staff ───────────────────────────────────────────────────────

      case adminStaff:
        final gymReceptionRepo = GymReceptionRepositoryImpl(GymReceptionService());
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BranchCubit()..loadBranches()),
                BlocProvider(
                  create: (_) => GymReceptionCubit(
                    getReception:    GetGymReceptionUseCase(gymReceptionRepo),
                    removeReception: RemoveGymReceptionUseCase(gymReceptionRepo),
                  )..load(),
                ),
              ],
              child: const AdminGymReceptionScreen(),
            ),
          ),
        );

    // ── Admin: Gym Profile ─────────────────────────────────────────────────

      case adminAiAssistant:
        final aiRepo = AiAssistantRepositoryImpl(
          service: AiAssistantRemoteService(),
        );
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BranchCubit()..loadBranches()),
                BlocProvider(
                  create: (_) => AiAssistantBloc(
                    sendAiQueryUseCase:           SendAiQueryUseCase(aiRepo),
                    getSuggestedQuestionsUseCase: GetSuggestedQuestionsUseCase(aiRepo),
                    getRecentQueriesUseCase:      GetRecentQueriesUseCase(aiRepo),
                  )..add(const AiAssistantStarted()),
                ),
              ],
              child: const AiAssistantScreen(),
            ),
          ),
        );

    // ── Admin: Branches ────────────────────────────────────────────────────

      case adminBranches:
        final branchesRepo = BranchRepositoryImpl();
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider<BranchesBloc>(
                  create: (_) => BranchesBloc(
                    getBranchesUseCase:     GetBranchesUseCase(branchesRepo),
                    getBranchDetailUseCase: GetBranchDetailUseCase(branchesRepo),
                    createBranchUseCase:    CreateBranchUseCase(branchesRepo),
                    updateBranchUseCase:    UpdateBranchUseCase(branchesRepo),
                    deleteBranchUseCase:    DeleteBranchUseCase(branchesRepo),
                  )..add(const LoadBranches()),
                ),
                BlocProvider<BranchCubit>(
                  create: (_) => BranchCubit()..loadBranches(),
                ),
              ],
              child: const BranchesListPage(),
            ),
          ),
        );

    // ── Admin: Check-ins ───────────────────────────────────────────────────

      case adminCheckins:
      // Read branchId from args — the nav drawer or dashboard passes it in.
      // Fallback to 1 (main branch) if not provided.
        final ciArgs    = settings.arguments as Map<String, dynamic>?;
        final ciBranchId = ciArgs?['branchId'] as int? ?? 1;

        final ciRepo = CheckinsRepositoryImpl(CheckinsRemoteDataSource());

        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BranchCubit()..loadBranches()),
                BlocProvider(
                  create: (_) => CheckinsBloc(
                    branchId:      ciBranchId,
                    getTodayCheckins: GetTodayCheckinsUseCase(ciRepo),
                    scanQrCheckin:    ScanQrCheckinUseCase(ciRepo),
                    checkOutMember:   CheckOutMemberUseCase(ciRepo),
                    freezeMember:     FreezeMemberUseCase(ciRepo),
                    blockMember:      BlockMemberUseCase(ciRepo),
                  ),
                ),
              ],
              child: const CheckinsScreen(),
            ),
          ),
        );
    // ── Admin: Payments ────────────────────────────────────────────────────

      case adminPayments:
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => BranchCubit()..loadBranches(),
                ),
                BlocProvider(
                  create: (_) =>
                      AdminPaymentConfigCubit(AdminPaymentConfigService()),
                ),
              ],
              child: const AdminPaymentConfigScreen(),
            ),
          ),
        );

    // ── Admin: Membership Requests ─────────────────────────────────────────

      case adminMembershipRequests:
        final mrRepo = AdminMembershipRequestsRepositoryImpl(
          AdminMembershipRequestsService(),
        );

        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => BranchCubit()..loadBranches(),
                ),
                BlocProvider(
                  create: (_) => AdminMembershipRequestsBloc(
                    getRequests: GetMembershipRequestsUseCase(mrRepo),
                    approve: ApproveMembershipRequestUseCase(mrRepo),
                    reject: RejectMembershipRequestUseCase(mrRepo),
                    getRefundRequests: GetRefundRequestsUseCase(mrRepo),
                    approveRefund: ApproveRefundRequestUseCase(mrRepo),
                    rejectRefund: RejectRefundRequestUseCase(mrRepo),
                  ),
                ),
              ],
              child: const AdminMembershipRequestsScreen(),
            ),
          ),
        );
    // ── Admin: Classes ─────────────────────────────────────────────────────

      case adminClasses:
        final classesRepo = AdminClassesRepositoryImpl(AdminClassesService());
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BranchCubit()..loadBranches()),
                BlocProvider(
                  create: (_) => AdminClassesBloc(
                    getClassesByDate:       GetClassesByDateUseCase(classesRepo),
                    getClassFormOptions:    GetClassFormOptionsUseCase(classesRepo),
                    createClass:            CreateClassUseCase(classesRepo),
                    updateClass:            UpdateClassUseCase(classesRepo),
                    cancelClass:            CancelClassUseCase(classesRepo),
                    reactivateClass:        ReactivateClassUseCase(classesRepo),
                    getSessionBookings:     GetSessionBookingsUseCase(classesRepo),
                    confirmBookingPayment:  ConfirmBookingPaymentUseCase(classesRepo),
                    rejectBooking:          RejectBookingUseCase(classesRepo),
                    approveCancellation:    ApproveCancellationUseCase(classesRepo),
                    declineCancellation:    DeclineCancellationUseCase(classesRepo),
                  )..add(ClassesStarted(DateTime.now())),
                ),
              ],
              child: const AdminClassesScreen(),
            ),
          ),
        );

    // ── Admin: Notifications ───────────────────────────────────────────────

      case adminNotifications:
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            const _ComingSoonScreen(title: 'Notifications'),
          ),
        );

    // ── Admin: PT Sessions ─────────────────────────────────────────────────

      case adminPtSessions:
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            BlocProvider(
              create: (_) => BranchCubit()..loadBranches(),
              child: const TrainerMainScreen(),
            ),
          ),
        );
    // ── Admin: PT Package Bookings (pending cash) ──────────────────────────

      case adminPtPackageBookings:
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BranchCubit()..loadBranches()),
              ],
              child: const AdminPtPackageBookingsScreen(),
            ),
          ),
        );

    // ── Admin: Training Videos ─────────────────────────────────────────────

      case adminTrainingVideos:
        final videosRepo = TrainingVideoRepositoryImpl(
          TrainingVideoRemoteDataSourceImpl(),
        );
        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(                          // ← was BlocProvider
              providers: [
                BlocProvider(                           // ← ADD THIS
                  create: (_) => BranchCubit()..loadBranches(),
                ),
                BlocProvider(
                  create: (_) => TrainingVideosBloc(
                    getTrainingVideosUseCase:    GetTrainingVideosUseCase(videosRepo),
                    getVideoCategoriesUseCase:   GetVideoCategoriesUseCase(videosRepo),
                    createTrainingVideoUseCase:  CreateTrainingVideoUseCase(videosRepo),
                    updateTrainingVideoUseCase:  UpdateTrainingVideoUseCase(videosRepo),
                    deleteVideoUseCase:          DeleteVideoUseCase(videosRepo),
                    getTrainersUseCase:          GetTrainersUseCase(videosRepo),
                    createCategoryUseCase:       CreateCategoryUseCase(videosRepo),
                  )..add(LoadTrainingVideos()),
                ),
              ],
              child: const TrainingVideosListPage(),
            ),
          ),
        );

    // ── Admin: Settings ────────────────────────────────────────────────────

      case adminSettings:
         final repo = AdminSettingsRepositoryImpl(AdminSettingsRemoteService());
         return MaterialPageRoute(
           builder: (_) => _withProfile(
             BlocProvider(
               create: (_) => AdminSettingsCubit(
                 getSettings: GetAdminSettingsUseCase(repo),
                 saveSettings: SaveAdminSettingsUseCase(repo),
               ),
               child: const AdminSettingsScreen(),
                   ),
           ),
       );

    // ── Admin: Invoices list ───────────────────────────────────────────────

      case '/admin/invoices':
        final invoicesRepo = AdminInvoiceRepositoryImpl(
          AdminInvoiceService(),
        );

        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => BranchCubit()..loadBranches(),
                ),
                BlocProvider(
                  create: (_) => AdminInvoicesListBloc(
                    listInvoices: ListInvoicesUseCase(invoicesRepo),
                  ),
                ),
              ],
              child: const AdminInvoicesListScreen(),
            ),
          ),
        );
    // ── Admin: Invoice detail ──────────────────────────────────────────────

      case '/admin/invoices/detail':
        final invoiceId = settings.arguments as int;
        final invoiceRepo = AdminInvoiceRepositoryImpl(
          AdminInvoiceService(),
        );

        return MaterialPageRoute(
          builder: (_) => _withProfile(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => BranchCubit()..loadBranches(),
                ),
                BlocProvider(
                  create: (_) => AdminInvoiceBloc(
                    getInvoice: GetInvoiceUseCase(invoiceRepo),
                  ),
                ),
              ],
              child: AdminInvoiceScreen(invoiceId: invoiceId),
            ),
          ),
        );
    // ── Logout ─────────────────────────────────────────────────────────────

      case logout:
        return MaterialPageRoute(
          builder: (_) => UserLoginScreen(appConfig: appConfig),
        );

    // ── 404 fallback ───────────────────────────────────────────────────────

      default:
        return MaterialPageRoute(
          builder: (_) =>
          const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}

// ─── Stub screen ─────────────────────────────────────────────────────────────
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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}