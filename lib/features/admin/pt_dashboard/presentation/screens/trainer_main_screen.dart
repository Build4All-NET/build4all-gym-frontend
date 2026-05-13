// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_main_screen.dart
//
// CHANGES:
//   1. Removed _TrainerPickerBar — admin now sees ALL trainers' data merged;
//      no single-trainer selection is needed.
//   2. Admin mode: _trainerId stays 0; bloc is started with trainerNames map
//      so it fetches sessions for every trainer in parallel.
//   3. Dashboard loading-forever fix: _buildBody no longer blocks on
//      _trainerId != 0 for admin; it renders once trainers are loaded.
//   4. isAdmin + trainers + trainerId passed to TrainerDashboardScreen so its
//      Quick Actions can open BookSessionSheet with all required params.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/AppBar/presentation/branch_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../../../admin/trainers/data/services/admin_trainers_service.dart';
import '../../../../auth/data/services/admin_token_store.dart';
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
  int  _tenantId   = 1;
  int  _trainerId  = 0;   // stays 0 for admin (all-trainers mode)
  bool _isAdmin    = false;
  bool _roleLoaded = false;
  AdminTokenStore token = AdminTokenStore();
  bool _profileSynced = false;

  List<AdminTrainerCardModel> _trainers      = [];
  bool    _loadingTrainers = false;
  String? _trainersError;

  late TrainerPtSessionsBloc _sessionsBloc;
  bool _blocInitialized = false;

  int _trainerRequestId = 0;
  late final requestId = ++_trainerRequestId;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_blocInitialized) {
      final service    = TrainerPtSessionsService();
      final repository = TrainerPtSessionsRepositoryImpl(service: service);
      _sessionsBloc = TrainerPtSessionsBloc(
        getSessions:   GetSessionsByDateUseCase(repository),
        getStats:      GetSessionStatsUseCase(repository),
        createSession: CreateSessionUseCase(repository),
        updateStatus:  UpdateSessionStatusUseCase(repository),
      );
      _blocInitialized = true;
    }
    if (!_profileSynced) {
      _profileSynced = true;
      _syncTrainerFromProfile(
        context.read<AdminProfileCubit>().state,
      );
    }
  }

  // ── Sync role + trainerId from profile ──────────────────────────────────────

  void _syncTrainerFromProfile(AdminProfile profile) {
    if (profile.role.isEmpty) return;

    final tenantId = token.getTenantId();
    final isAdmin  = profile.isAdminRole;

    if (!_roleLoaded) setState(() => _roleLoaded = true);

    if (_tenantId != tenantId || _isAdmin != isAdmin) {
      final tenantIdRaw = token.getTenantId();
      final parsedTenantId = int.tryParse(tenantIdRaw.toString()) ?? 1;

      setState(() {
        _tenantId = parsedTenantId;
        _isAdmin = isAdmin;
      });    }

    if (profile.isTrainerRole) {
      // TRAINER: use own userId
      final newId = profile.userId ?? 0;
      if (newId != 0 && _trainerId != newId) {
        setState(() => _trainerId = newId);
        _sessionsBloc.add(PtSessionsStarted(
          branchId:  _effectiveBranchId(context),
          trainerId: newId,
        ));
      }
    } else if (profile.isAdminRole && _trainers.isEmpty && !_loadingTrainers) {
      // ADMIN/OWNER: load trainer list, then start bloc in all-trainers mode
      _loadTrainersForAdmin();
    }
  }

  @override
  void dispose() {
    _sessionsBloc.close();
    super.dispose();
  }

  int _effectiveBranchId(BuildContext context) {
    if (_selectedBranchId != null) return _selectedBranchId!;
    final s = context.read<BranchCubit>().state;
    if (s is BranchLoaded && s.branches.isNotEmpty) return s.branches.first.id;
    return 1;
  }

  Future<void> _loadTrainersForAdmin() async {
    final currentRequest = ++_trainerRequestId;
    if (!mounted) return;
    setState(() { _loadingTrainers = true; _trainersError = null; });
    try {
      final branchId = _effectiveBranchId(context);
      final response = await AdminTrainersService().getTrainers(branchId: branchId);
      if (!mounted) return;
      setState(() {
        _trainers        = response.trainers;
        _loadingTrainers = false;
        // _trainerId stays 0 — admin sees ALL trainers merged
      });
        _sessionsBloc.add(
          PtSessionsStarted(
            branchId: _effectiveBranchId(context),
            trainerId: 0,
            trainerNames: {
              for (final t in _trainers) t.trainerId: t.fullName,
            },
          ),
        );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingTrainers = false;
        _trainersError   = 'Could not load trainers. Please check your connection and retry.';
      });
    }
  }

  void _switchTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  void _onBranchChanged(int? branchId) {
    if (!mounted || requestId != _trainerRequestId) return;
    setState(() {
      _selectedBranchId = branchId;
      if (_isAdmin) {
        _trainers      = [];
        _trainersError = null;
        // _trainerId stays 0
      }
    });
    if (_isAdmin) {
      _loadTrainersForAdmin();
    } else if (_trainerId != 0) {
      final id = branchId ?? _effectiveBranchId(context);
      _sessionsBloc.add(PtSessionsStarted(
        branchId:  id,
        trainerId: _trainerId,
      ));
    }
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
    return BlocListener<AdminProfileCubit, AdminProfile>(
      listenWhen: (prev, curr) =>
      prev.role != curr.role || prev.userId != curr.userId,
      listener: (_, profile) => _syncTrainerFromProfile(profile),
      child: BlocProvider.value(
        value: _sessionsBloc,
        child: _buildBody(effectiveBranchId),
      ),
    );
  }

  Widget _buildBody(int effectiveBranchId) {
    // Role not yet decoded → show spinner
    if (!_roleLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Admin: trainers still loading → spinner
    if (_isAdmin && _loadingTrainers) {
      return _buildResolving();
    }

    // Admin: trainer load failed → error with retry
    if (_isAdmin && _trainersError != null && _trainers.isEmpty) {
      return _buildResolving();
    }

    // Trainer: own userId not resolved yet → spinner
    if (!_isAdmin && _trainerId == 0) {
      return _buildResolving();
    }

    return _MainShell(
      currentIndex:    _currentIndex,
      onTabSwitch:     _switchTab,
      navItems:        _navItems,
      tenantId:        _tenantId,
      branchId:        effectiveBranchId,
      // trainerId = 0 for admin (all-trainers); own ID for trainer
      trainerId:       _trainerId,
      isAdmin:         _isAdmin,
      trainers:        _trainers,
      onBranchChanged: _onBranchChanged,
    );
  }

  Widget _buildResolving() {
    if (_trainersError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people_outline_rounded,
                    size: 56, color: Color(0xFFEF4444)),
                const SizedBox(height: 16),
                Text(
                  _trainersError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loadTrainersForAdmin,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// ── Shell ─────────────────────────────────────────────────────────────────────

class _MainShell extends StatelessWidget {
  final int                        currentIndex;
  final ValueChanged<int>          onTabSwitch;
  final List<_NavItem>             navItems;
  final int                        tenantId;
  final int                        branchId;
  final int                        trainerId;
  final bool                       isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final ValueChanged<int?>         onBranchChanged;

  const _MainShell({
    required this.currentIndex,
    required this.onTabSwitch,
    required this.navItems,
    required this.tenantId,
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;

    // ValueKey rebuilds a tab when branchId changes (not on trainer selection
    // because admin always shows all trainers — no per-trainer rebuild needed).
    final bodies = <Widget>[
      TrainerDashboardScreen(
        key:             ValueKey('dashboard_$branchId'),
        onTabSwitch:     onTabSwitch,
        onBranchChanged: onBranchChanged,
        isAdmin:         isAdmin,
        trainers:        trainers,
        trainerId:       trainerId,
      ),
      TrainerPtSessionsScreen(
        key:       ValueKey('sessions_$branchId'),
        branchId:  branchId,
        trainerId: trainerId,
        isAdmin:   isAdmin,
        trainers:  trainers,
      ),
      TrainerPackagesScreen(
        key:       ValueKey('packages_$branchId'),
        tenantId:  tenantId,
        branchId:  branchId,
        trainerId: trainerId,
        isAdmin:   isAdmin,
        trainers:  trainers,
      ),
      TrainerScheduleScreen(
        key:       ValueKey('schedule_$branchId'),
        branchId:  branchId,
        trainerId: trainerId,
        isAdmin:   isAdmin,
        trainers:  trainers,
      ),
      TrainerServicesScreen(
        key:      ValueKey('services_$branchId'),
        tenantId: tenantId,
      ),
    ];

    return Scaffold(
      backgroundColor: cs.background,
      body: IndexedStack(
        index:    currentIndex,
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
                    onTap:    () => onTabSwitch(i),
                    behavior: HitTestBehavior.opaque,
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