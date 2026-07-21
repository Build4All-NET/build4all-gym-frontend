// =============================================================================
// FILE: checkins_screen.dart
// PATH: lib/features/admin/checkins/presentation/screens/checkins_screen.dart
// LAYER: Presentation Layer → Screens
//
// PURPOSE:
//   Main scaffold for the admin check-ins screen.
//   Layout (top → bottom):
//     1. AdminAppBar  (hamburger | branch pill | title | QR icon | bell)
//     2. CheckinStatsRow  (Active Now card + Total Today card)
//     3. CheckinsSearchBar  (debounced search)
//     4. CheckinsList  (section header + member cards)
//
// STATE HANDLING:
//   BlocListener reacts to:
//     • CheckinsScanSuccess → green snackbar + auto-reload (BLoC handles reload)
//     • CheckinsActionSuccess → green snackbar
//     • CheckinsActionError → red snackbar
//   BlocBuilder inside child widgets handles loading/loaded/error for the list.
//
// LIVE UPDATES:
//   There's no push from the backend, so "live" is simulated here:
//     • A periodic silent poll re-fetches every 25s without showing the
//       loading skeleton (so another device's check-in appears on its own).
//     • Pull-to-refresh triggers a normal (non-silent) reload on demand.
//
// BRANCH:
//   Defaults to the admin's own branch (decoded from the JWT via
//   AdminProfileCubit) once it resolves; the router's branchId=1 is only a
//   transient first-paint fallback. Picking a branch from the AppBar pill
//   dispatches ChangeBranch, which updates CheckinsBloc.branchId and reloads.
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/backend_error_code_translator.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/checkins_bloc.dart';
import '../widgets/checkin_date_filter_widget.dart';
import '../widgets/checkin_stats_row.dart';
import '../widgets/checkins_list.dart';
import '../widgets/checkins_search_bar.dart';
import '../widgets/qr_scanner_sheet.dart';

class CheckinsScreen extends StatefulWidget {
  const CheckinsScreen({super.key});

  @override
  State<CheckinsScreen> createState() => _CheckinsScreenState();
}

class _CheckinsScreenState extends State<CheckinsScreen> {
  int? _selectedBranchId;
  // Becomes true once the admin's home branch (from the profile/JWT) has
  // been applied, or once the admin picks a branch manually — either way we
  // then stop overriding the selection on profile rebuilds.
  bool _branchResolved = false;

  // Null means "today". Polling is skipped while a past date is selected —
  // there's nothing "live" to poll for on a historical day.
  DateTime? _selectedDate;

  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    // Load the list when the screen first mounts.
    context.read<CheckinsBloc>().add(const LoadTodayCheckins());

    // Simulate "live" updates: the backend has no push mechanism, so poll
    // quietly in the background while this screen is open.
    _pollTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (mounted && _selectedDate == null) {
        context.read<CheckinsBloc>().add(const LoadTodayCheckins(silent: true));
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<CheckinsBloc>();
    bloc.add(const LoadTodayCheckins());
    await bloc.stream.firstWhere(
        (s) => s is CheckinsLoaded || s is CheckinsError);
  }

  void _onBranchChanged(int? branchId) {
    // branchId is null when the admin explicitly picks "All Branches" from
    // the pill — that must stay null so stats/list aggregate tenant-wide
    // instead of silently falling back to the admin's home branch.
    setState(() {
      _selectedBranchId = branchId;
      _branchResolved    = true;
    });
    context.read<CheckinsBloc>().add(ChangeBranch(branchId));
  }

  void _onDateChanged(DateTime? date) {
    setState(() => _selectedDate = date);
    context.read<CheckinsBloc>().add(FilterByDate(date));
  }

  void _onScanTap(BuildContext context, AppLocalizations l10n) {
    if (_selectedBranchId == null) {
      _showSnack(context, l10n.checkins_allBranchesScanBlocked, isError: true);
      return;
    }
    showQrScannerSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final l10n    = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    // The profile's branchId resolves asynchronously (JWT decode). As soon
    // as it's known, correct the bloc/pill from the router's `1` fallback —
    // but only if the admin hasn't already picked a branch themselves.
    if (!_branchResolved && profile.branchId != null) {
      _branchResolved   = true;
      _selectedBranchId = profile.branchId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CheckinsBloc>().add(ChangeBranch(profile.branchId!));
        }
      });
    }

    return BlocListener<CheckinsBloc, CheckinsState>(
      // Only react to result states — not to loading/loaded list states.
      listenWhen: (_, curr) =>
      curr is CheckinsScanSuccess  ||
          curr is CheckinsActionSuccess ||
          curr is CheckinsActionError,
      listener: (context, state) {
        if (state is CheckinsScanSuccess) {
          final msg = state.checkedOut
              ? '${state.memberName} ${l10n.checkins_scanCheckedOutMsg}'
              : '${state.memberName} ${l10n.checkins_scanSuccessMsg}';
          _showSnack(context, msg, isError: false);
        } else if (state is CheckinsActionSuccess) {
          _showSnack(context, state.message, isError: false);
        } else if (state is CheckinsActionError) {
          _showSnack(context, translateBackendErrorCode(l10n, state.errorCode),
              isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: c.background,
        drawer: SafeArea(
          child: AdminNavigationDrawer(
            gymName:         profile.gymName,
            branchName:      profile.branchName,
            adminName:       profile.adminName,
            adminEmail:      profile.adminEmail,
            avatarUrl:       profile.avatarUrl,
            initialActiveId: 'checkins',
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── AppBar ───────────────────────────────────────────────────
              AdminAppBar(
                title:            l10n.checkins_title,
                selectedBranchId: _selectedBranchId,
                onBranchChanged:  _onBranchChanged,
                actions: [
                  // QR scan icon — opens the camera bottom sheet.
                  IconButton(
                    icon:  Icon(Icons.qr_code_scanner_rounded,
                        color: c.label, size: 22),
                    tooltip:   l10n.checkins_scanQr,
                    onPressed: () => _onScanTap(context, l10n),
                  ),
                ],
              ),

              // ── Scrollable body ─────────────────────────────────────────
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),

                        // Stat cards row
                        const CheckinStatsRow(),
                        const SizedBox(height: 16),

                        // Search bar
                        const CheckinsSearchBar(),
                        const SizedBox(height: 8),

                        // Date filter
                        CheckinDateFilterWidget(
                          selectedDate: _selectedDate,
                          onChanged:    _onDateChanged,
                        ),
                        const SizedBox(height: 4),

                        // Today's list
                        const CheckinsList(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext ctx, String msg, {required bool isError}) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content:         Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        duration:        const Duration(seconds: 3),
        behavior:        SnackBarBehavior.floating,
      ),
    );
  }
}
