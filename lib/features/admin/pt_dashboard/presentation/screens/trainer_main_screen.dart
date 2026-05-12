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
// Branch selection lives here: the selected branchId is passed to every tab
// that needs it. When the user switches branch, all tabs reload via ValueKey.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/AppBar/presentation/branch_cubit.dart';
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
  final int initialIndex;
  const TrainerMainScreen({super.key, this.initialIndex = 0});

  @override
  State<TrainerMainScreen> createState() => _TrainerMainScreenState();
}

class _TrainerMainScreenState extends State<TrainerMainScreen> {
  late int _currentIndex;
  int? _selectedBranchId;
  int  _tenantId = 1;
  late TrainerPtSessionsBloc _sessionsBloc;
  bool _blocInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_blocInitialized) {
      // tenantId = gym-chain identifier stored at login (ownerProjectLinkId).
      // AdminProfileCubit exposes it as .branchId (legacy naming in that cubit).
      final profileState = context.read<AdminProfileCubit>().state;
      _tenantId = profileState.branchId ?? 1;

      final branchId = _effectiveBranchId(context);
      final service = TrainerPtSessionsService();
      final repository = TrainerPtSessionsRepositoryImpl(service: service);
      _sessionsBloc = TrainerPtSessionsBloc(
        getSessions:   GetSessionsByDateUseCase(repository),
        getStats:      GetSessionStatsUseCase(repository),
        createSession: CreateSessionUseCase(repository),
        updateStatus:  UpdateSessionStatusUseCase(repository),
      )..add(PtSessionsStarted(branchId: branchId));
      _blocInitialized = true;
    }
  }

  @override
  void dispose() {
    _sessionsBloc.close();
    super.dispose();
  }

  int _effectiveBranchId(BuildContext context) {
    if (_selectedBranchId != null) return _selectedBranchId!;
    final branchState = context.read<BranchCubit>().state;
    if (branchState is BranchLoaded && branchState.branches.isNotEmpty) {
      return branchState.branches.first.id;
    }
    return 1;
  }

  void _switchTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  void _onBranchChanged(int? branchId) {
    setState(() => _selectedBranchId = branchId);
    final effectiveId = branchId ?? _effectiveBranchId(context);
    _sessionsBloc.add(PtSessionsStarted(branchId: effectiveId));
  }

  static const _navItems = <_NavItem>[
    _NavItem(icon: Icons.grid_view_rounded,      label: 'Dashboard'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'Sessions'),
    _NavItem(icon: Icons.inventory_2_outlined,   label: 'Packages'),
    _NavItem(icon: Icons.schedule_rounded,       label: 'Schedule'),
    _NavItem(icon: Icons.people_outline_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final effectiveBranchId = _effectiveBranchId(context);

    return BlocProvider.value(
      value: _sessionsBloc,
      child: _MainShell(
        currentIndex:    _currentIndex,
        onTabSwitch:     _switchTab,
        navItems:        _navItems,
        tenantId:        _tenantId,
        branchId:        effectiveBranchId,
        onBranchChanged: _onBranchChanged,
      ),
    );
  }
}

// ── Shell widget ──────────────────────────────────────────────────────────────

class _MainShell extends StatelessWidget {
  final int               currentIndex;
  final ValueChanged<int>  onTabSwitch;
  final List<_NavItem>    navItems;
  final int               tenantId;
  final int               branchId;
  final ValueChanged<int?> onBranchChanged;

  const _MainShell({
    required this.currentIndex,
    required this.onTabSwitch,
    required this.navItems,
    required this.tenantId,
    required this.branchId,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;

    // ValueKey ensures tabs fully rebuild (and reload data) when branchId changes.
    final bodies = <Widget>[
      TrainerDashboardScreen(
        key: ValueKey('dashboard_$branchId'),
        onTabSwitch:     onTabSwitch,
        onBranchChanged: onBranchChanged,
      ),
      const TrainerPtSessionsScreen(),
      TrainerPackagesScreen(
        key:      ValueKey('packages_$branchId'),
        tenantId: tenantId,
        branchId: branchId,
      ),
      TrainerScheduleScreen(
        key:      ValueKey('schedule_$branchId'),
        branchId: branchId,
      ),
      TrainerServicesScreen(
        key:      ValueKey('services_$branchId'),
        tenantId: tenantId,
      ),
    ];

    return Scaffold(
      backgroundColor: cs.background,
      body: IndexedStack(
        index: currentIndex,
        children: bodies,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset:     const Offset(0, -4),
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

class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}
