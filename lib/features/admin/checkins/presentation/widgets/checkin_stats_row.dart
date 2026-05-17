// =============================================================================
// FILE: checkin_stats_row.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkin_stats_row.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   Renders the two stat cards (Active Now, Total Today) in a horizontal row.
//   Reads the BLoC state directly — shows skeleton when loading.
//
// COLORS:
//   Left (Active Now)  → green tint  → AppThemeTokens.colors.success
//   Right (Total Today)→ blue tint   → Colors.blue[700] (no blue token exists yet)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/checkins_bloc.dart';
import 'checkin_stat_card.dart';

class CheckinStatsRow extends StatelessWidget {
  const CheckinStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n   = AppLocalizations.of(context)!;

    return BlocBuilder<CheckinsBloc, CheckinsState>(
      buildWhen: (prev, curr) =>
      curr is CheckinsLoading ||
          curr is CheckinsLoaded  ||
          curr is CheckinsError,
      builder: (context, state) {
        final isLoading = state is CheckinsLoading || state is CheckinsInitial;
        final activeNow  = state is CheckinsLoaded ? state.stats.activeNow  : 0;
        final totalToday = state is CheckinsLoaded ? state.stats.totalToday : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // ── Left: Active Now ─────────────────────────────────────────
              CheckinStatCard(
                icon:      Icons.person_rounded,
                value:     activeNow,
                label:     l10n.checkins_activeNow,
                tintColor: tokens.colors.success,
                iconColor: tokens.colors.success,
                isLoading: isLoading,
              ),
              const SizedBox(width: 12),
              // ── Right: Total Today ────────────────────────────────────────
              CheckinStatCard(
                icon:      Icons.access_time_rounded,
                value:     totalToday,
                label:     l10n.checkins_totalToday,
                tintColor: const Color(0xFF1D4ED8), // blue-700
                iconColor: const Color(0xFF1D4ED8),
                isLoading: isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
