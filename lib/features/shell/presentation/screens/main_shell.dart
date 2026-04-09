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

class MainShell extends StatefulWidget {
  final AppConfig appConfig;

  const MainShell({super.key, required this.appConfig});

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
    final token  = g.readAuthToken();
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

  @override
  Widget build(BuildContext context) {
    final tokens   = context.read<ThemeCubit>().state.tokens;
    final c        = tokens.colors;
    final menuType = context.read<ThemeCubit>().state.menuType;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) =>
                  UserLoginScreen(appConfig: widget.appConfig),
            ),
                (_) => false,
          );
        }
      },
      child: menuType == 'drawer'
          ? _buildDrawerShell(c)
          : _buildBottomNavShell(c),
    );
  }

  // ─── Bottom nav layout ───────────────────────────────────────────────────────

  Widget _buildBottomNavShell(c) {
    final pages = _pages();

    return Scaffold(
      body: Column(
        children: [
          const ConnectionBanner(),
          Expanded(child: pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        indicatorColor: c.primary.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center_rounded),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ─── Drawer layout ───────────────────────────────────────────────────────────

  Widget _buildDrawerShell(c) {
    final pages = _pages();

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
              title: const Text('Home'),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center_outlined),
              title: const Text('Activities'),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: const Text('Profile'),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
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

  // ─── Page stubs (replace with real screens) ──────────────────────────────────

  List<Widget> _pages() => [
    _HomeTab(onLogout: _logout),
    const _ActivitiesTab(),
    const _ProfileTab(),
  ];
}

// ─── Placeholder tabs ─────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final VoidCallback onLogout;
  const _HomeTab({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.home_rounded, size: 64),
          const SizedBox(height: 16),
          const Text('Home', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ActivitiesTab extends StatelessWidget {
  const _ActivitiesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Activities'));
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
          const Icon(Icons.person_rounded, size: 64),
          const SizedBox(height: 12),
          Text(user?.displayName ?? 'Profile',
              style: const TextStyle(fontSize: 18)),
          if (user?.email != null) ...[
            const SizedBox(height: 4),
            Text(user!.email!, style: const TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}