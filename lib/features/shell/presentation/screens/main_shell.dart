import 'package:build4allgym/features/member/account/domain/repositories/member_account_repository.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_bloc.dart';
import 'package:build4allgym/features/member/account/presentation/screens/member_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/network/globals.dart' as g;
import 'package:build4allgym/core/realtime/realtime_cubit.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_banner.dart';

import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_state.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

import 'package:build4allgym/features/member/home/presentation/screens/member_home_screen.dart';
import 'package:build4allgym/features/member/home/presentation/widgets/member_bottom_nav_bar.dart';
import 'package:build4allgym/features/member/pt/presentation/screens/member_pt_screen.dart';

import 'package:build4allgym/features/member/home/data/services/member_home_remote_datasource.dart';
import 'package:build4allgym/features/member/home/data/repositories/member_home_repository_impl.dart';
import 'package:build4allgym/features/member/home/domain/usecases/get_member_home_usecase.dart';
import 'package:build4allgym/features/member/home/domain/usecases/log_weight_usecase.dart';
import 'package:build4allgym/features/member/home/presentation/bloc/member_home_bloc.dart';

import 'package:build4allgym/features/member/plans/presentation/screens/member_plans_screen.dart';

import 'package:build4allgym/l10n/app_localizations.dart';

import '../../../member/account/data/repositories/member_account_repository_impl.dart';
import '../../../member/account/data/services/member_account_service.dart';
import '../../../member/account/domain/usecases/get_member_account_usecase.dart';
import '../../../member/account/domain/usecases/update_profile_usecase.dart';

import '../../../member/build4all_profile/data/repositories/member_build4all_profile_repository_impl.dart';
import '../../../member/build4all_profile/data/services/member_build4all_profile_service.dart';
import '../../../member/build4all_profile/domain/usecases/get_member_build4all_profile_usecase.dart';
import '../../../member/build4all_profile/presentation/bloc/member_build4all_profile_bloc.dart';
import '../../../member/build4all_profile/presentation/bloc/member_build4all_profile_event.dart';

import '../../../member/sessions/data/repositories/sessions_repository_impl.dart';
import '../../../member/sessions/domain/usecases/book_session_usecase.dart';
import '../../../member/sessions/domain/usecases/cancel_booking_usecase.dart';
import '../../../member/sessions/domain/usecases/get_filter_options_usecase.dart';
import '../../../member/sessions/domain/usecases/get_sessions_usecase.dart';
import '../../../member/sessions/data/services/sessions_service.dart';
import '../../../member/sessions/domain/usecases/get_session_detail_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../member/sessions/presentation/screens/sessions_page.dart';

import '../../../member/qr/data/repositories/member_qr_repository_impl.dart';
import '../../../member/qr/data/services/member_qr_service.dart';
import '../../../member/qr/domain/usecases/get_member_qr_use_case.dart';
import '../../../member/qr/domain/usecases/refresh_member_qr_use_case.dart';
import '../../../member/qr/presentation/bloc/member_qr_bloc.dart';
import '../../../member/qr/presentation/bloc/member_qr_event.dart';
import '../../../member/qr/presentation/screens/member_qr_screen.dart';
class MainShell extends StatefulWidget {
  final AppConfig appConfig;

  const MainShell({
    super.key,
    required this.appConfig,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _cachedPages;

  @override
  void initState() {
    super.initState();

    // Build tab pages once.
    // This prevents MemberAccountScreen and its blocs from being recreated
    // whenever theme/locale changes rebuild MainShell.
    _cachedPages = _buildPages();

    _startRealtime();
  }

  void _startRealtime() {
    final token = g.readAuthToken();
    final tenant = widget.appConfig.ownerProjectId ?? 0;

    if (token.isNotEmpty && tenant > 0) {
      context.read<RealtimeCubit>().bind(
        tokenMaybeBearerOrRaw: token,
        tenantId: tenant,
      );
    }
  }

  void _logout() {
    context.read<RealtimeCubit>().bind(
      tokenMaybeBearerOrRaw: '',
      tenantId: 0,
    );

    context.read<AuthBloc>().add(const AuthLoggedOut());
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final menuType = context.read<ThemeCubit>().state.menuType;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => UserLoginScreen(appConfig: widget.appConfig),
            ),
                (_) => false,
          );
        }
      },
      child: menuType == 'drawer'
          ? _buildDrawerShell(c)
          : _buildBottomNavShell(),
    );
  }

  Widget _buildBottomNavShell() {
    return Scaffold(
      body: Column(
        children: [
          const ConnectionBanner(),
          Expanded(child: _cachedPages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: MemberBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildDrawerShell(c) {

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appConfig.appName),
        backgroundColor: c.surface,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: c.primary),
              child: Center(
                child: Text(
                  widget.appConfig.appName,
                  style: TextStyle(
                    color: c.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: Text(l10n.memberBottomNavHome),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: Text(l10n.memberBottomNavPlans),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_2_rounded),
              title: Text(l10n.memberBottomNavQr),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(l10n.memberBottomNavClasses),
              selected: _currentIndex == 3,
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center_rounded),
              title: Text(l10n.memberBottomNavBookTrainer),
              selected: _currentIndex == 4,
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.memberBottomNavAccount),
              selected: _currentIndex == 5,
              onTap: () {
                setState(() => _currentIndex = 5);
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: Text(l10n.navLogout),
              onTap: _logout,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          const ConnectionBanner(),
          Expanded(child: _cachedPages[_currentIndex]),
        ],
      ),
    );
  }

  List<Widget> _buildPages() => [
    BlocProvider<MemberHomeBloc>(
      create: (_) {
        final datasource = MemberHomeRemoteDatasource(
          tokenStore: const AuthTokenStore(),
        );
        final repository = MemberHomeRepositoryImpl(datasource);

        return MemberHomeBloc(
          getMemberHomeUseCase: GetMemberHomeUseCase(repository),
          logWeightUseCase: LogWeightUseCase(repository),
        );
      },
      child: MemberHomeScreen(
        onTabSelected: _onBottomNavTap,
      ),
    ),

    MemberPlansScreenProvider(
      dio: g.dio(),
    ),

    const _QrTab(),

    SessionsPage(
      getSessionsUseCase: GetSessionsUseCase(
        SessionsRepositoryImpl(
          SessionsService(g.dio()),
        ),
      ),
      getSessionDetailUseCase: GetSessionDetailUseCase(
        SessionsRepositoryImpl(SessionsService(g.dio())),
      ),
      bookSessionUseCase: BookSessionUseCase(
        SessionsRepositoryImpl(
          SessionsService(g.dio()),
        ),
      ),
      cancelBookingUseCase: CancelBookingUseCase(
        SessionsRepositoryImpl(
          SessionsService(g.dio()),
        ),
      ),
      getFilterOptionsUseCase: GetFilterOptionsUseCase(
        SessionsRepositoryImpl(
          SessionsService(g.dio()),
        ),
      ),
    ),

    const MemberPtScreen(showBackButton: false),

    MultiBlocProvider(
      providers: [
        BlocProvider<MemberBuild4AllProfileBloc>(
          create: (_) {
            final build4allRepo = MemberBuild4AllProfileRepositoryImpl(
              MemberBuild4AllProfileService(),
            );

            return MemberBuild4AllProfileBloc(
              getProfileUseCase: GetMemberBuild4AllProfileUseCase(
                build4allRepo,
              ),
            )..add(const MemberBuild4AllProfileStarted());
          },
        ),
      ],
      child: MemberAccountScreen(
        bloc: MemberAccountBloc(
          getMemberAccountUseCase: GetMemberAccountUseCase(
            MemberAccountRepositoryImpl(
              MemberAccountService(g.dio()),
            ),
          ),
          updateProfileUseCase: UpdateProfileUseCase(
            MemberAccountRepositoryImpl(
              MemberAccountService(g.dio()),
            ),
          ),
        ),
      ),
    ),
  ];
}

class _QrTab extends StatelessWidget {
  const _QrTab();

  @override
  Widget build(BuildContext context) {
    /*
     * Same project style:
     * dependencies are created near the screen using BlocProvider.
     *
     * Chain:
     * Service -> RepositoryImpl -> UseCases -> Bloc -> Screen
     */
    final service = MemberQrService();

    final repository = MemberQrRepositoryImpl(
      service: service,
    );

    return BlocProvider(
      create: (_) => MemberQrBloc(
        getMemberQrUseCase: GetMemberQrUseCase(
          repository: repository,
        ),
        refreshMemberQrUseCase: RefreshMemberQrUseCase(
          repository: repository,
        ),
      )..add(const LoadMemberQr()),
      child: const MemberQrScreen(),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_rounded,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 12),
          Text(
            user?.displayName ?? l10n.profileFallbackLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (user?.email != null) ...[
            const SizedBox(height: 4),
            Text(
              user!.email!,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLoggedOut());
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(l10n.navLogout),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}