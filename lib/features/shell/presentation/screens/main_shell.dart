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

import 'package:build4allgym/features/member/home/data/services/member_home_remote_datasource.dart';
import 'package:build4allgym/features/member/home/data/repositories/member_home_repository_impl.dart';
import 'package:build4allgym/features/member/home/domain/usecases/get_member_home_usecase.dart';
import 'package:build4allgym/features/member/home/domain/usecases/log_weight_usecase.dart';
import 'package:build4allgym/features/member/home/presentation/bloc/member_home_bloc.dart';
import 'package:dio/dio.dart';
import 'package:build4allgym/features/member/plans/presentation/screens/member_plans_screen.dart';

import 'package:build4allgym/l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
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

    if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.comingSoon),
        ),
      );
    }
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
    final pages = _pages();

    return Scaffold(
      body: Column(
        children: [
          const ConnectionBanner(),
          Expanded(child: pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: MemberBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildDrawerShell(c) {
    final pages = _pages();
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
                Navigator.pop(context);
                _showComingSoon();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.memberBottomNavAccount),
              selected: _currentIndex == 4,
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: _logout,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          const ConnectionBanner(),
          Expanded(child: pages[_currentIndex]),
        ],
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.comingSoon),
      ),
    );
  }

  List<Widget> _pages() => [
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
      child: const MemberHomeScreen(),
    ),
    MemberPlansScreenProvider(
      dio: Dio(),
    ),
    const _QrTab(),
    const _ClassesTab(),
    const _ProfileTab(),
  ];
}


class _QrTab extends StatelessWidget {
  const _QrTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('QR'));
  }
}

class _ClassesTab extends StatelessWidget {
  const _ClassesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Classes'));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_rounded, size: 64, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 12),
          Text(
            user?.displayName ?? 'Profile',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          if (user?.email != null) ...[
            const SizedBox(height: 4),
            Text(user!.email!, style: const TextStyle(color: Colors.grey)),
          ],
          const SizedBox(height: 32),
          // LOGOUT BUTTON
          ElevatedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLoggedOut());
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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