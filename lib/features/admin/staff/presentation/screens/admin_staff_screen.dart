// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/screens/admin_staff_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:build4allgym/features/admin/navigation/presentation/widgets/admin_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/network/globals.dart';
import 'package:build4allgym/features/admin/AppBar/presentation/admin_app_bar.dart';
import 'package:build4allgym/features/admin/AppBar/presentation/branch_cubit.dart';

import '../../data/repositories/admin_staff_repository_impl.dart';
import '../../data/services/admin_staff_service.dart';
import '../../domain/usecases/create_staff_usecase.dart';
import '../../domain/usecases/get_staff_usecase.dart';
import '../../domain/usecases/remove_staff_usecase.dart';
import '../../domain/usecases/update_staff_usecase.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';
import '../bloc/admin_staff_state.dart';
import '../widgets/add_edit_staff_dialog.dart';
import '../widgets/staff_card_widget.dart';
import '../widgets/staff_search_bar_widget.dart';
import '../widgets/staff_stats_row_widget.dart';

class AdminStaffScreen extends StatelessWidget {
  const AdminStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final service = AdminStaffService(dio());
        final repo    = AdminStaffRepositoryImpl(service);
        return AdminStaffBloc(
          getStaff:    GetStaffUseCase(repo),
          createStaff: CreateStaffUseCase(repo),
          updateStaff: UpdateStaffUseCase(repo),
          removeStaff: RemoveStaffUseCase(repo),
        )..add(const StaffStarted());
      },
      child: const _AdminStaffView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// StatefulWidget so we can track _selectedBranchId for the branch pill
// ─────────────────────────────────────────────────────────────────────────────
class _AdminStaffView extends StatefulWidget {
  const _AdminStaffView();

  @override
  State<_AdminStaffView> createState() => _AdminStaffViewState();
}

class _AdminStaffViewState extends State<_AdminStaffView> {
  int? _selectedBranchId; // null = All Branches

  @override
  void initState() {
    super.initState();
    // Load branches for the pill — safe to call if already loaded (no-op)
    context.read<BranchCubit>().loadBranches();
  }

  void _onBranchChanged(int? branchId) {
    setState(() => _selectedBranchId = branchId);
    // Re-fetch staff filtered by the newly selected branch
    context.read<AdminStaffBloc>().add(
      StaffStarted(branchId: branchId),
    );
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminStaffBloc>(),
        child: const AddEditStaffDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: const AdminNavigationDrawer(
          gymName:         'Build4All Gym',
          branchName:      'Downtown',
          adminName:       'Mounir',
          adminEmail:      'mounir@gym.com',
          avatarUrl:       null,
          initialActiveId: 'reception_staff',
        ),
        backgroundColor: const Color(0xFFF5F7FA),
        // ── No appBar property — AdminAppBar lives inside the body ──────────
        body: SafeArea(
          child: Column(
            children: [
              // ── Shared Admin AppBar ───────────────────────────────────────
              AdminAppBar(
                title:            'Staff',
                selectedBranchId: _selectedBranchId,
                onBranchChanged:  _onBranchChanged,
                onAddTap:         _openAddDialog,
                notificationCount: 0, // TODO: wire to real notification count
              ),

              // ── Body ──────────────────────────────────────────────────────
              Expanded(
                child: BlocConsumer<AdminStaffBloc, AdminStaffState>(
                  listener: (context, state) {
                    if (state is StaffActionSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_successMessage(state.actionType)),
                          backgroundColor: const Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }
                    if (state is StaffActionError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: const Color(0xFFDC2626),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is StaffLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is StaffError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Color(0xFFDC2626)),
                            const SizedBox(height: 12),
                            Text(state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color(0xFF64748B))),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context
                                  .read<AdminStaffBloc>()
                                  .add(StaffStarted(
                                  branchId: _selectedBranchId)),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is StaffLoaded ||
                        state is StaffActionLoading ||
                        state is StaffActionSuccess ||
                        state is StaffActionError) {
                      final loaded = _lastLoaded(context);
                      if (loaded == null) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          // ── Stats row ─────────────────────────────────────
                          StaffStatsRowWidget(
                            totalStaff:  loaded.totalStaff,
                            activeStaff: loaded.activeStaff,
                          ),
                          // ── Search bar ────────────────────────────────────
                          const StaffSearchBarWidget(),
                          // ── Staff list ────────────────────────────────────
                          Expanded(
                            child: loaded.staff.isEmpty
                                ? const Center(
                              child: Text(
                                'No staff members found.',
                                style: TextStyle(
                                    color: Color(0xFF94A3B8)),
                              ),
                            )
                                : ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 100),
                              itemCount: loaded.staff.length,
                              itemBuilder: (ctx, i) =>
                                  StaffCardWidget(
                                      staff: loaded.staff[i]),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),

        // ── FAB ───────────────────────────────────────────────────────────────
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddDialog,
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  StaffLoaded? _lastLoaded(BuildContext context) {
    final s = context.read<AdminStaffBloc>().state;
    if (s is StaffLoaded) return s;
    return null;
  }

  String _successMessage(String actionType) {
    return switch (actionType) {
      'create' => 'Staff member added successfully',
      'update' => 'Staff member updated successfully',
      'remove' => 'Staff member removed successfully',
      _        => 'Action completed successfully',
    };
  }
}