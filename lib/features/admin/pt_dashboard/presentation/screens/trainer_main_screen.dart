// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_main_screen.dart
//
// FIXES:
//   1. Fixed stuck on loading - _roleLoaded now set even when role is empty
//   2. Fixed trainerId=0 infinite loading - shows error with retry instead
//   3. Removed _profileSynced guard - allows re-sync on profile updates
//   4. Bloc starts even with edge cases, API handles errors
//   5. Added proper error UI for trainer ID not found
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/AppBar/presentation/branch_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../../../admin/trainers/data/services/admin_trainers_service.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../data/repositories/availability_repository_impl.dart';
import '../../data/repositories/pt_service_repository_impl.dart';
import '../../data/services/availability_service.dart';
import '../../data/services/pt_service_service.dart';
import '../../domain/repositories/trainer_pt_sessions_repository.dart';
import '../../domain/usecases/availability_usecases.dart';
import '../../domain/usecases/pt_service_usecases.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/services/pt_service_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_bloc.dart';
import '../../data/repositories/pt_package_repository_impl.dart';
import '../../data/repositories/trainer_pt_sessions_repository_impl.dart';
import '../../data/services/pt_package_service.dart';
import '../../data/services/trainer_pt_sessions_service.dart';
import '../../domain/usecases/pt_package_usecases.dart';
import '../../domain/usecases/trainer_pt_sessions_usecases.dart';
import '../bloc/packages/pt_package_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_event.dart';

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
  int  _trainerId  = 0;   // 0 = admin all-trainers mode
  bool _isAdmin    = true;
  bool _roleLoaded = false;
  final AdminTokenStore _token = AdminTokenStore();

  List<AdminTrainerCardModel> _trainers      = [];
  bool    _loadingTrainers = false;
  String? _trainersError;

  late TrainerPtSessionsBloc _sessionsBloc;
  bool _blocInitialized = false;

  int _trainerRequestId = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Initialize bloc immediately in initState
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // REMOVED _profileSynced guard - always sync when dependencies change
    final profile = context.read<AdminProfileCubit>().state;
    _syncTrainerFromProfile(profile);
  }

  // ── Sync role + trainerId from profile ──────────────────────────────────────

  void _syncTrainerFromProfile(AdminProfile profile) {
    // FIX #1: Set _roleLoaded = true EVEN when role is empty
    // so we stop showing loading spinner and show error instead
    if (profile.role.isEmpty) {
      if (!_roleLoaded) {
        setState(() => _roleLoaded = true);
      }
      return;
    }

    print('the role is $_token.getRole()');

    final tenantIdRaw = _token.getTenantId();
    final parsedTenantId = int.tryParse(tenantIdRaw.toString()) ?? 1;
    final isAdmin  = profile.isAdminRole;
    final isTrainer = profile.isTrainerRole;

    // FIX #2: Always set _roleLoaded = true here so loading stops
    if (!_roleLoaded) {
      setState(() => _roleLoaded = true);
    }

    setState(() {
      _tenantId = parsedTenantId;
      _isAdmin = isAdmin;
    });

    if (isTrainer && !isAdmin) {
      // TRAINER: use own userId
      final newId = profile.userId ?? 0;

      // FIX #3: Always set trainerId, even if 0
      // Don't block on 0 - let _buildBody show error UI
      if (_trainerId != newId) {
        setState(() => _trainerId = newId);
      }

      // Start bloc if we have a valid ID
      if (newId != 0) {
        _sessionsBloc.add(PtSessionsStarted(
          branchId:  _effectiveBranchId(context),
          trainerId: newId,
        ));
      }
    } else if (isAdmin && _trainers.isEmpty && !_loadingTrainers) {
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
    return context.read<AdminProfileCubit>().state.branchId ?? 1;
  }

  Future<void> _loadTrainersForAdmin() async {
    final currentRequest = ++_trainerRequestId;
    if (!mounted) return;
    setState(() { _loadingTrainers = true; _trainersError = null; });
    try {
      final branchId = _effectiveBranchId(context);
      final response = await AdminTrainersService().getTrainers(branchId: branchId);
      if (!mounted || currentRequest != _trainerRequestId) return;
      setState(() {
        _trainers        = response.trainers;
        _loadingTrainers = false;
      });
      // Start bloc with all trainers mode
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
      if (!mounted || currentRequest != _trainerRequestId) return;
      print('❌ _loadTrainersForAdmin error: $e'); // ADD THIS

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
    if (!mounted) return;
    setState(() {
      _selectedBranchId = branchId;
      if (_isAdmin) {
        _trainers      = [];
        _trainersError = null;
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
      prev.role != curr.role || prev.userId != curr.userId || prev.branchId != curr.branchId || prev.gymRole != curr.gymRole,
      listener: (_, profile) => _syncTrainerFromProfile(profile),
      child: BlocProvider.value(
        value: _sessionsBloc,
        child: _buildBody(effectiveBranchId),
      ),
    );
  }

  Widget _buildBody(int effectiveBranchId) {
    // Role not yet decoded -> show spinner
    if (!_roleLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Admin: trainers still loading -> spinner
    if (_isAdmin && _loadingTrainers) {

      return _buildResolving();
    }

    // Admin: trainer load failed -> error with retry
    if (_isAdmin && _trainersError != null && _trainers.isEmpty) {
      return _buildResolving();
    }

    // FIX #4: Trainer with userId=0 - show ERROR instead of infinite loading
    if (!_isAdmin && _trainerId == 0) {
      return _buildTrainerIdError();
    }

    return _MainShell(
      currentIndex:    _currentIndex,
      onTabSwitch:     _switchTab,
      navItems:        _navItems,
      tenantId:        _tenantId,
      branchId:        effectiveBranchId,
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

  // NEW: Error UI when trainerId is 0 (not found in profile)
  Widget _buildTrainerIdError() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_off_outlined,
                  size: 56, color: Color(0xFFEF4444)),
              const SizedBox(height: 16),
              const Text(
                'Trainer ID not found in profile.\nPlease log out and log in again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Retry reading profile
                  final profile = context.read<AdminProfileCubit>().state;
                  _syncTrainerFromProfile(profile);
                },
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
    final bodies = <Widget>[
      TrainerDashboardScreen(
        key:             ValueKey('dashboard_${branchId}_${isAdmin ? 0 : trainerId}'),
        onTabSwitch:     onTabSwitch,
        onBranchChanged: onBranchChanged,
        isAdmin:         isAdmin,
        trainers:        trainers,
        trainerId:       trainerId,
      ),

      // Sessions tab — uses the shared _sessionsBloc already provided above via BlocProvider.value
      TrainerPtSessionsScreen(
        key:       ValueKey('sessions_${branchId}_${isAdmin ? 0 : trainerId}'),
        branchId:  branchId,
        trainerId: trainerId,
        isAdmin:   isAdmin,
        trainers:  trainers,
      ),

      // Packages tab
      BlocProvider(
        create: (_) => PtPackageBloc(
          getPackages:         GetPtPackagesUseCase(PtPackageRepositoryImpl(service: PtPackageService())),
          getInactivePackages: GetInactivePtPackagesUseCase(PtPackageRepositoryImpl(service: PtPackageService())),
          createPackage:       CreatePtPackageUseCase(PtPackageRepositoryImpl(service: PtPackageService())),
          updatePackage:       UpdatePtPackageUseCase(PtPackageRepositoryImpl(service: PtPackageService())),
          deactivatePackage:   DeactivatePtPackageUseCase(PtPackageRepositoryImpl(service: PtPackageService())),
        ),
        child: TrainerPackagesScreen(
          tenantId:  tenantId,
          branchId:  branchId,
          trainerId: trainerId,
          isAdmin:   isAdmin,
          trainers:  trainers,
        ),
      ),

      // Schedule tab
      BlocProvider(
        create: (_) => AvailabilityBloc(
          getSlots:    GetAvailabilitySlotsUseCase(AvailabilityRepositoryImpl(service: AvailabilityHttpService())),
          createSlot:  CreateAvailabilitySlotUseCase(AvailabilityRepositoryImpl(service: AvailabilityHttpService())),
          deleteSlot:  DeleteAvailabilitySlotUseCase(AvailabilityRepositoryImpl(service: AvailabilityHttpService())),
        ),
        child: TrainerScheduleScreen(
          key:       ValueKey('schedule_${branchId}_${isAdmin ? 0 : trainerId}'),
          branchId:  branchId,
          trainerId: trainerId,
          isAdmin:   isAdmin,
          trainers:  trainers,
        ),
      ),

      // Services tab
      BlocProvider(
        create: (_) => PtServiceBloc(
          getServices:    GetPtServicesUseCase(PtServiceRepositoryImpl(service: PtServiceService())),
          createService:  CreatePtServiceUseCase(PtServiceRepositoryImpl(service: PtServiceService())),
          updateService:  UpdatePtServiceUseCase(PtServiceRepositoryImpl(service: PtServiceService())),
          deleteService:  DeletePtServiceUseCase(PtServiceRepositoryImpl(service: PtServiceService())),
        ),
        child: TrainerServicesScreen(
          key:       ValueKey('services_${branchId}'),
          tenantId:  tenantId,
          trainerId: trainerId,
          isAdmin:   isAdmin,
          trainers:  trainers,
        ),
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
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
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