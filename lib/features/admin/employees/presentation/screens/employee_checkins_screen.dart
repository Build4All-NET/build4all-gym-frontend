// FILE: lib/features/admin/employees/presentation/screens/employee_checkins_screen.dart
//
// Employee Check-Ins:
//   Trainers/reception scan the branch's static QR poster to self check-in/
//   out (toggle). Standalone employees with no app account are checked in/
//   out manually by an admin/reception staffer from this same list.

import 'dart:async';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../../checkins/presentation/widgets/checkin_stat_card.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/employee_checkin_row_entity.dart';
import '../bloc/employee_checkins/employee_checkins_bloc.dart';
import '../widgets/employee_checkin_row_widget.dart';
import '../widgets/employee_qr_scanner_sheet.dart';
import '../widgets/branch_checkin_qr_dialog.dart';
import '../../../../../l10n/app_localizations.dart';

class EmployeeCheckinsScreen extends StatefulWidget {
  const EmployeeCheckinsScreen({super.key});

  @override
  State<EmployeeCheckinsScreen> createState() => _EmployeeCheckinsScreenState();
}

class _EmployeeCheckinsScreenState extends State<EmployeeCheckinsScreen> {
  int? _selectedBranchId;
  bool _branchResolved = false;
  Timer? _pollTimer;

  // Tracks which row's manual action is in flight, so only that row shows a spinner.
  int? _busyEmployeeId;

  @override
  void initState() {
    super.initState();
    context.read<BranchCubit>().loadBranches();
    context.read<EmployeeCheckinsBloc>().add(const LoadTodayEmployeeCheckins());

    _pollTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (mounted) {
        context.read<EmployeeCheckinsBloc>().add(const LoadTodayEmployeeCheckins(silent: true));
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _onBranchChanged(int? branchId) {
    final effective = branchId ?? context.read<AdminProfileCubit>().state.branchId ?? 1;
    setState(() {
      _selectedBranchId = effective;
      _branchResolved = true;
    });
    context.read<EmployeeCheckinsBloc>().add(ChangeEmployeeCheckinsBranch(effective));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    if (!_branchResolved && profile.branchId != null) {
      _branchResolved = true;
      _selectedBranchId = profile.branchId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<EmployeeCheckinsBloc>().add(ChangeEmployeeCheckinsBranch(profile.branchId!));
        }
      });
    }

    return BlocListener<EmployeeCheckinsBloc, EmployeeCheckinsState>(
      listenWhen: (_, curr) =>
          curr is EmployeeCheckinsActionSuccess || curr is EmployeeCheckinsActionError,
      listener: (context, state) {
        setState(() => _busyEmployeeId = null);
        if (state is EmployeeCheckinsActionSuccess) {
          AppToast.success(context, state.message);
        } else if (state is EmployeeCheckinsActionError) {
          AppToast.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: c.background,
        drawer: SafeArea(
          child: AdminNavigationDrawer(
            gymName: profile.gymName,
            branchName: profile.branchName,
            adminName: profile.adminName,
            adminEmail: profile.adminEmail,
            avatarUrl: profile.avatarUrl,
            initialActiveId: 'employee_checkins',
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminAppBar(
                title: l10n.admin_employees_checkinsTitle,
                selectedBranchId: _selectedBranchId,
                onBranchChanged: _onBranchChanged,
                actions: [
                  if (profile.isAdminRole)
                    IconButton(
                      icon: Icon(Icons.qr_code_2_rounded, color: c.label, size: 22),
                      tooltip: l10n.admin_employees_showGymQr,
                      onPressed: () {
                        final bloc = context.read<EmployeeCheckinsBloc>();
                        BranchCheckinQrDialog.show(
                          context,
                          branchId: bloc.branchId,
                          getBranchQr: bloc.getBranchQr,
                        );
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner_rounded, color: c.label, size: 22),
                    tooltip: l10n.admin_employees_scanToCheckInOut,
                    onPressed: () => showEmployeeQrScannerSheet(context),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<EmployeeCheckinsBloc, EmployeeCheckinsState>(
                  // Action success/error states are transient (snackbar-only, handled by
                  // the BlocListener above) — ignoring them here keeps the list on screen
                  // instead of it flashing blank every time someone taps Check In/Out.
                  buildWhen: (_, curr) =>
                      curr is EmployeeCheckinsLoading ||
                      curr is EmployeeCheckinsInitial ||
                      curr is EmployeeCheckinsError ||
                      curr is EmployeeCheckinsLoaded,
                  builder: (context, state) {
                    final isLoading = state is EmployeeCheckinsLoading || state is EmployeeCheckinsInitial;
                    final List<EmployeeCheckinRowEntity> rows =
                        state is EmployeeCheckinsLoaded ? state.rows : const [];
                    final activeNow = rows.where((r) => r.isCheckedIn).length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (profile.isAdminRole) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: Row(
                              children: [
                                CheckinStatCard(
                                  icon: Icons.how_to_reg_rounded,
                                  value: activeNow,
                                  label: l10n.admin_employees_checkedInNow,
                                  tintColor: c.success,
                                  iconColor: c.success,
                                  isLoading: isLoading,
                                ),
                                const SizedBox(width: 12),
                                CheckinStatCard(
                                  icon: Icons.groups_rounded,
                                  value: rows.length,
                                  label: l10n.admin_employees_totalStaff,
                                  tintColor: const Color(0xFF1D4ED8),
                                  iconColor: const Color(0xFF1D4ED8),
                                  isLoading: isLoading,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Expanded(child: _buildBody(context, state, c, l10n)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    EmployeeCheckinsState state,
    ColorTokens c,
    AppLocalizations l10n,
  ) {
    if (state is EmployeeCheckinsLoading || state is EmployeeCheckinsInitial) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: 5,
        itemBuilder: (_, __) => const _RowSkeleton(),
      );
    }

    if (state is EmployeeCheckinsError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: c.danger, size: 48),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: c.muted)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<EmployeeCheckinsBloc>().add(const LoadTodayEmployeeCheckins()),
              style: ElevatedButton.styleFrom(backgroundColor: c.primary, foregroundColor: c.onPrimary),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (state is EmployeeCheckinsLoaded) {
      if (state.rows.isEmpty) {
        return RefreshIndicator(
          color: c.primary,
          onRefresh: () async =>
              context.read<EmployeeCheckinsBloc>().add(const LoadTodayEmployeeCheckins()),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(48),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.badge_outlined, size: 48, color: c.muted.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text(l10n.admin_employees_noActiveEmployeesYet,
                          style: TextStyle(color: c.muted, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: c.primary,
        onRefresh: () async =>
            context.read<EmployeeCheckinsBloc>().add(const LoadTodayEmployeeCheckins()),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: state.rows.length,
          itemBuilder: (context, i) {
            final row = state.rows[i];
            return EmployeeCheckinRowWidget(
              row: row,
              isBusy: _busyEmployeeId == row.employeeId,
              onCheckIn: () {
                setState(() => _busyEmployeeId = row.employeeId);
                context.read<EmployeeCheckinsBloc>().add(ManualCheckinEvent(row.employeeId));
              },
              onCheckOut: () {
                if (row.employeeCheckinId == null) return;
                setState(() => _busyEmployeeId = row.employeeId);
                context.read<EmployeeCheckinsBloc>().add(ManualCheckoutEvent(row.employeeCheckinId!));
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ── Loading skeleton row — shown while the first load is in flight ───────────
class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
