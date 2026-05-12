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
  List<AdminTrainerCardModel> _trainers = [];

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

    // Sync trainerId from profile every time dependencies change.
    // The cubit loads async so this may run before role is available;
    // the BlocListener in build() handles the late-arrival case.
    _syncTrainerFromProfile(context.read<AdminProfileCubit>().state);
  }

  void _syncTrainerFromProfile(AdminProfile profile) {
    if (profile.role.isEmpty) return; // not loaded yet — BlocListener will handle
    final tenantId = profile.branchId ?? 1;
    final isAdmin  = profile.isAdminRole;

    if (_tenantId != tenantId || _isAdmin != isAdmin) {
      setState(() {
        _tenantId = tenantId;
        _isAdmin  = isAdmin;
      });
    }

    if (profile.isTrainerRole && _trainerId == 0) {
      final newId = profile.userId ?? 0;
      setState(() => _trainerId = newId);
      if (newId != 0) {
        _sessionsBloc.add(PtSessionsStarted(
          branchId:  _effectiveBranchId(context),
          trainerId: newId,
        ));
      }
    } else if (profile.isAdminRole && _trainers.isEmpty && _trainerId == 0) {
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
    try {
      final branchId = _effectiveBranchId(context);
      final response = await AdminTrainersService().getTrainers(branchId: branchId);
      if (!mounted) return;
      setState(() {
        _trainers = response.trainers;
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
    } catch (_) {
      // Trainer picker will remain empty; admin can retry by switching branch.
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
        _trainers  = [];
        _trainerId = 0;
        _loadTrainersForAdmin(); // fires PtSessionsStarted once new trainers load
      }
    });
    if (!_isAdmin && _trainerId != 0) {
      final effectiveId = branchId ?? _effectiveBranchId(context);
      _sessionsBloc.add(PtSessionsStarted(branchId: effectiveId, trainerId: _trainerId));
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
      // Fire when profile finishes loading (role goes from '' to real value).
      listenWhen: (prev, curr) => prev.role != curr.role || prev.userId != curr.userId,
      listener:   (_, profile) => _syncTrainerFromProfile(profile),
      child: BlocProvider.value(
      value: _sessionsBloc,
      child: _MainShell(
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
      ),
    ),
    );
  }
}

// ── Shell widget ──────────────────────────────────────────────────────────────

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
  final ValueChanged<int>          onTrainerChanged;

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
        key:             ValueKey('dashboard_$branchId'),
        onTabSwitch:     onTabSwitch,
        onBranchChanged: onBranchChanged,
      ),
      const TrainerPtSessionsScreen(),
      TrainerPackagesScreen(
        key:       ValueKey('packages_${branchId}_$trainerId'),
        tenantId:  tenantId,
        branchId:  branchId,
        trainerId: trainerId,
      ),
      TrainerScheduleScreen(
        key:       ValueKey('schedule_${branchId}_$trainerId'),
        branchId:  branchId,
        trainerId: trainerId,
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
            'Trainer:',
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
