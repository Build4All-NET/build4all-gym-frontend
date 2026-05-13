// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_main_screen.dart
//
// FIX SUMMARY:
//   1. Dashboard loading-forever bug — _trainerId=0 gate now waits for role.
//      If role is not loaded yet we show a spinner, not an error.
//   2. Admin sees ALL trainers via picker bar; trainer auto-uses own ID.
//   3. All sub-screens (sessions, packages, schedule, services) receive
//      isAdmin + trainers list so they can behave differently per role.
//   4. TrainerPtSessionsScreen now receives branchId + trainerId directly
//      instead of reading them from a partially-initialised bloc.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/AppBar/presentation/branch_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../../../admin/trainers/data/services/admin_trainers_service.dart';
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
  int  _tenantId  = 1;
  int  _trainerId = 0;
  bool _isAdmin   = false;
  bool _roleLoaded = false; // ← NEW: track whether role has been decoded

  List<AdminTrainerCardModel> _trainers      = [];
  bool    _loadingTrainers = false;
  String? _trainersError;

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
    _syncTrainerFromProfile(context.read<AdminProfileCubit>().state);
  }

  // ── Sync role + trainerId from profile ──────────────────────────────────────

  void _syncTrainerFromProfile(AdminProfile profile) {
    // Role not decoded yet — BlocListener will call us again when it arrives.
    if (profile.role.isEmpty) return;

    final tenantId = profile.branchId ?? 1;
    final isAdmin  = profile.isAdminRole;

    // Role has been decoded at least once.
    if (!_roleLoaded) {
      setState(() { _roleLoaded = true; });
    }

    if (_tenantId != tenantId || _isAdmin != isAdmin) {
      setState(() {
        _tenantId = tenantId;
        _isAdmin  = isAdmin;
      });
    }

    if (profile.isTrainerRole) {
      // TRAINER: use own userId directly.
      final newId = profile.userId ?? 0;
      if (newId != 0 && _trainerId != newId) {
        setState(() => _trainerId = newId);
        _sessionsBloc.add(PtSessionsStarted(
          branchId:  _effectiveBranchId(context),
          trainerId: newId,
        ));
      }
    } else if (profile.isAdminRole && _trainers.isEmpty && !_loadingTrainers) {
      // ADMIN/OWNER: load trainer list to populate the picker.
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
    final branchState = context.read<BranchCubit>().state;
    if (branchState is BranchLoaded && branchState.branches.isNotEmpty) {
      return branchState.branches.first.id;
    }
    return 1;
  }

  Future<void> _loadTrainersForAdmin() async {
    if (!mounted) return;
    setState(() { _loadingTrainers = true; _trainersError = null; });
    try {
      final branchId = _effectiveBranchId(context);
      final response = await AdminTrainersService().getTrainers(branchId: branchId);
      if (!mounted) return;
      setState(() {
        _trainers        = response.trainers;
        _loadingTrainers = false;
        // Auto-select first trainer for the bloc.
        if (_trainers.isNotEmpty && _trainerId == 0) {
          _trainerId = _trainers.first.trainerId;
        }
      });
      if (_trainerId != 0) {
        _sessionsBloc.add(PtSessionsStarted(
          branchId:  _effectiveBranchId(context),
          trainerId: _trainerId,
        ));
      }
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
    setState(() {
      _selectedBranchId = branchId;
      if (_isAdmin) {
        _trainers      = [];
        _trainerId     = 0;
        _trainersError = null;
      }
    });
    if (_isAdmin) {
      _loadTrainersForAdmin();
    } else if (_trainerId != 0) {
      final effectiveId = branchId ?? _effectiveBranchId(context);
      _sessionsBloc.add(PtSessionsStarted(
          branchId: effectiveId, trainerId: _trainerId));
    }
  }

  void _onTrainerChanged(int trainerId) {
    setState(() => _trainerId = trainerId);
    _sessionsBloc.add(PtSessionsStarted(
      branchId:  _effectiveBranchId(context),
      trainerId: trainerId,
    ));
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
    // Role not decoded yet → show spinner (prevents false "loading trainers" loop)
    if (!_roleLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Admin: trainers still loading
    if (_isAdmin && _loadingTrainers && _trainerId == 0) {
      return _buildResolving();
    }

    // Trainer with no ID yet
    if (!_isAdmin && _trainerId == 0) {
      return _buildResolving();
    }

    // Error state (admin failed to load trainers)
    if (_trainersError != null && _trainerId == 0) {
      return _buildResolving();
    }

    return _MainShell(
      currentIndex:     _currentIndex,
      onTabSwitch:      _switchTab,
      navItems:         _navItems,
      tenantId:         _tenantId,
      branchId:         effectiveBranchId,
      trainerId:        _trainerId,
      isAdmin:          _isAdmin,
      trainers:         _trainers,
      onBranchChanged:  _onBranchChanged,
      onTrainerChanged: _onTrainerChanged,
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
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF6B7280)),
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ── Shell ─────────────────────────────────────────────────────────────────────

class _MainShell extends StatelessWidget {
  final int                         currentIndex;
  final ValueChanged<int>           onTabSwitch;
  final List<_NavItem>              navItems;
  final int                         tenantId;
  final int                         branchId;
  final int                         trainerId;
  final bool                        isAdmin;
  final List<AdminTrainerCardModel>  trainers;
  final ValueChanged<int?>          onBranchChanged;
  final ValueChanged<int>           onTrainerChanged;

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
    required this.onTrainerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;

    // ValueKey rebuilds (and reloads) a tab when trainerId or branchId changes.
    final bodies = <Widget>[
      TrainerDashboardScreen(
        key:             ValueKey('dashboard_${branchId}_$trainerId'),
        onTabSwitch:     onTabSwitch,
        onBranchChanged: onBranchChanged,
      ),
      TrainerPtSessionsScreen(
        key:       ValueKey('sessions_${branchId}_$trainerId'),
        branchId:  branchId,
        trainerId: trainerId,
        isAdmin:   isAdmin,
        trainers:  trainers,
      ),
      TrainerPackagesScreen(
        key:       ValueKey('packages_${branchId}_$trainerId'),
        tenantId:  tenantId,
        branchId:  branchId,
        trainerId: trainerId,
        isAdmin:   isAdmin,
        trainers:  trainers,
      ),
      TrainerScheduleScreen(
        key:       ValueKey('schedule_${branchId}_$trainerId'),
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
      body: Column(
        children: [
          // Trainer picker bar — only for admin/owner when trainers loaded.
          if (isAdmin && trainers.isNotEmpty)
            _TrainerPickerBar(
              trainers:          trainers,
              selectedTrainerId: trainerId,
              onChanged:         onTrainerChanged,
            ),
          if (isAdmin && trainers.isEmpty)
            const _TrainerPickerLoading(),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: bodies,
            ),
          ),
        ],
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

// ── Trainer picker bar (admin/owner only) ─────────────────────────────────────

class _TrainerPickerBar extends StatelessWidget {
  final List<AdminTrainerCardModel> trainers;
  final int                         selectedTrainerId;
  final ValueChanged<int>           onChanged;

  const _TrainerPickerBar({
    required this.trainers,
    required this.selectedTrainerId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = trainers.any((t) => t.trainerId == selectedTrainerId)
        ? selectedTrainerId
        : trainers.first.trainerId;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.person_outline_rounded,
              size: 18, color: Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          const Text(
            'Viewing Trainer:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selected,
                isExpanded: true,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
                items: trainers
                    .map((t) => DropdownMenuItem(
                  value: t.trainerId,
                  child: Text(t.fullName,
                      overflow: TextOverflow.ellipsis),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerPickerLoading extends StatelessWidget {
  const _TrainerPickerLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text(
            'Loading trainers…',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}