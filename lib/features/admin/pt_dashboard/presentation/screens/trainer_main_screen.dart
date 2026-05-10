// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/screens/trainer_main_screen.dart
//
// DESIGN: Bottom navigation shell for the trainer-side app.
//
// Tabs (matching screenshots 8, 10):
//   0 — Dashboard  (Images 1-2)
//   1 — Sessions   (Image 12)
//   2 — Packages   (Images 3-7)
//   3 — Schedule   (Images 8-9)
//   4 — More / Services (Images 10-11)
//
// Navigation contract:
//   - The BLoC is provided here so ALL tabs share the same instance.
//   - Quick actions on the Dashboard call [_switchTab] to jump to the
//     relevant tab — the user can always return by tapping the tab bar.
//   - IndexedStack keeps each tab alive (no rebuild on tab switch).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../data/repositories/trainer_pt_sessions_repository_impl.dart';
import '../../data/services/trainer_pt_sessions_service.dart';
import '../../domain/usecases/trainer_pt_sessions_usecases.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_event.dart';
import '../widgets/book_session_sheet_widget.dart';

import 'trainer_dashboard_screen.dart';
import 'trainer_packages_screen.dart';
import 'trainer_pt_sessions_screen.dart';
import 'trainer_schedule_screen.dart';
import 'trainer_services_screen.dart';

class TrainerMainScreen extends StatefulWidget {
  /// Optional initial tab index.  Useful when deep-linking into a specific tab.
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

  // ── Bottom nav items ────────────────────────────────────────────────────────

  static const _navItems = <_NavItem>[
    _NavItem(icon: Icons.grid_view_rounded,      label: 'Dashboard'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'Sessions'),
    _NavItem(icon: Icons.inventory_2_outlined,   label: 'Packages'),
    _NavItem(icon: Icons.schedule_rounded,       label: 'Schedule'),
    _NavItem(icon: Icons.people_outline_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final service    = TrainerPtSessionsService();
    final repository = TrainerPtSessionsRepositoryImpl(service: service);

    return BlocProvider(
      create: (_) => TrainerPtSessionsBloc(
        getSessions:   GetSessionsByDateUseCase(repository),
        getStats:      GetSessionStatsUseCase(repository),
        createSession: CreateSessionUseCase(repository),
        updateStatus:  UpdateSessionStatusUseCase(repository),
      )..add(const PtSessionsStarted(branchId: 1)), // TODO: real branchId
      child: _MainShell(
        currentIndex: _currentIndex,
        onTabSwitch:  _switchTab,
        navItems:     _navItems,
      ),
    );
  }
}

// ── Shell (receives BLoC from above) ─────────────────────────────────────────

class _MainShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSwitch;
  final List<_NavItem> navItems;

  const _MainShell({
    required this.currentIndex,
    required this.onTabSwitch,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;

    // Build tab bodies — passing onTabSwitch where navigation is needed.
    final bodies = <Widget>[
      // 0: Dashboard — receives callback so quick actions can switch tabs.
      TrainerDashboardScreen(onTabSwitch: onTabSwitch),

      // 1: Sessions — standalone, Book Session sheet opens from AppBar.
      const TrainerPtSessionsScreen(),

      // 2: Packages
      const TrainerPackagesScreen(),

      // 3: Schedule
      const TrainerScheduleScreen(),

      // 4: More / Services
      const TrainerServicesScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // IndexedStack keeps all tabs alive to preserve scroll position / state.
      body: IndexedStack(
        index: currentIndex,
        children: bodies,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(navItems.length, (i) {
                final selected = i == currentIndex;
                final item     = navItems[i];
                return Expanded(
                  child: InkWell(
                    onTap: () => onTabSwitch(i),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF4F46E5).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: selected
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFF9CA3AF),
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

// ── Nav item data ─────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
