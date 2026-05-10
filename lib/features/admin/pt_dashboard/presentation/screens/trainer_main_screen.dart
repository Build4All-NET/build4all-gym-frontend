// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_main_screen.dart
//
// Bottom navigation shell for the trainer-side (PT) app.
//
// Tabs:
//   0  Dashboard   — TrainerDashboardScreen
//   1  Sessions    — TrainerPtSessionsScreen
//   2  Packages    — TrainerPackagesScreen
//   3  Schedule    — TrainerScheduleScreen
//   4  More        — TrainerServicesScreen
//
// BLoC contract:
//   TrainerPtSessionsBloc is provided HERE so all 5 tabs share the same
//   instance. IndexedStack keeps every tab alive (no rebuild on tab switch).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';

import '../../data/repositories/trainer_pt_sessions_repository_impl.dart';
import '../../data/services/trainer_pt_sessions_service.dart';
import '../../domain/usecases/trainer_pt_sessions_usecases.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_event.dart';

import 'trainer_dashboard_screen.dart';
import 'trainer_packages_screen.dart';
import 'trainer_pt_sessions_screen.dart';
import 'trainer_schedule_screen.dart';
import 'trainer_services_screen.dart';

class TrainerMainScreen extends StatefulWidget {
  /// Optional initial tab index. Useful when deep-linking into a specific tab.
  final int initialIndex;

  const TrainerMainScreen({super.key, this.initialIndex = 0});

  @override
  State<TrainerMainScreen> createState() => _TrainerMainScreenState();
}

class _TrainerMainScreenState extends State<TrainerMainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _switchTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  // ── Bottom nav tab definitions ─────────────────────────────────────────────
  static const _navItems = <_NavItem>[
    _NavItem(icon: Icons.grid_view_rounded,      label: 'Dashboard'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'Sessions'),
    _NavItem(icon: Icons.inventory_2_outlined,   label: 'Packages'),
    _NavItem(icon: Icons.schedule_rounded,       label: 'Schedule'),
    _NavItem(icon: Icons.people_outline_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {

    //      AdminProfileCubit.state.branchId holds the tenant/branch ID that was
    //      stored at login by AdminTokenStore (from the auth response).
    //      We fall back to 1 only if the token did not carry a branchId claim,
    //      which should never happen in production.
    final profile  = context.read<AdminProfileCubit>().state;
    final branchId = profile.branchId ?? 1;

    final service    = TrainerPtSessionsService();
    final repository = TrainerPtSessionsRepositoryImpl(service: service);

    return BlocProvider(
      create: (_) => TrainerPtSessionsBloc(
        getSessions:   GetSessionsByDateUseCase(repository),
        getStats:      GetSessionStatsUseCase(repository),
        createSession: CreateSessionUseCase(repository),
        updateStatus:  UpdateSessionStatusUseCase(repository),
      )..add(PtSessionsStarted(branchId: branchId)), //  real branchId
      child: _MainShell(
        currentIndex: _currentIndex,
        onTabSwitch:  _switchTab,
        navItems:     _navItems,
      ),
    );
  }
}

// ── Shell widget (receives BLoC from above via context) ───────────────────────

class _MainShell extends StatelessWidget {
  final int              currentIndex;
  final ValueChanged<int> onTabSwitch;
  final List<_NavItem>   navItems;

  const _MainShell({
    required this.currentIndex,
    required this.onTabSwitch,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;

    // Each tab is built once and kept alive by IndexedStack.
    final bodies = <Widget>[
      // Tab 0: Dashboard — receives onTabSwitch so quick actions switch tabs.
      TrainerDashboardScreen(onTabSwitch: onTabSwitch),
      // Tab 1: Sessions
      const TrainerPtSessionsScreen(),
      // Tab 2: Packages
      const TrainerPackagesScreen(),
      // Tab 3: Schedule
      const TrainerScheduleScreen(),
      // Tab 4: More / Services
      const TrainerServicesScreen(),
    ];

    return Scaffold(
      backgroundColor: cs.background,
      // IndexedStack preserves scroll position and BLoC state across tab switches
      body: IndexedStack(
        index: currentIndex,
        children: bodies,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color:     Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset:    const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(navItems.length, (i) {
                final isActive = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap:     () => onTabSwitch(i),
                    behavior:  HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          navItems[i].icon,
                          size:  22,
                          color: isActive ? cs.primary : cs.muted,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          navItems[i].label,
                          style: TextStyle(
                            fontSize:   10,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive ? cs.primary : cs.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Simple data class for nav tab definitions ─────────────────────────────────
class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}