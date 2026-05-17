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
// BRANCH:
//   The selected branchId comes from BranchCubit (the branch pill in the AppBar).
//   When the admin changes branch, we reload the list for the new branch.
//   The BLoC itself stores branchId — here we just fire LoadTodayCheckins.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/checkins_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    // Load the list when the screen first mounts.
    context.read<CheckinsBloc>().add(const LoadTodayCheckins());
  }

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final l10n    = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    return BlocListener<CheckinsBloc, CheckinsState>(
      // Only react to result states — not to loading/loaded list states.
      listenWhen: (_, curr) =>
      curr is CheckinsScanSuccess  ||
          curr is CheckinsActionSuccess ||
          curr is CheckinsActionError,
      listener: (context, state) {
        if (state is CheckinsScanSuccess) {
          _showSnack(context,
              '${state.memberName} ${l10n.checkins_scanSuccessMsg}',
              isError: false);
        } else if (state is CheckinsActionSuccess) {
          _showSnack(context, state.message, isError: false);
        } else if (state is CheckinsActionError) {
          _showSnack(context, state.message, isError: true);
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
                title: l10n.checkins_title,
                actions: [
                  // QR scan icon — opens the camera bottom sheet.
                  IconButton(
                    icon:  Icon(Icons.qr_code_scanner_rounded,
                        color: c.label, size: 22),
                    tooltip:   l10n.checkins_scanQr,
                    onPressed: () => showQrScannerSheet(context),
                  ),
                ],
              ),

              // ── Scrollable body ─────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
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

                      // Today's list
                      const CheckinsList(),
                      const SizedBox(height: 24),
                    ],
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
