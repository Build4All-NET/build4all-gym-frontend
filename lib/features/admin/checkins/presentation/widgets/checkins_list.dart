// =============================================================================
// FILE: checkins_list.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkins_list.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   Section header ("Today's Check-ins") + the scrollable list of member cards.
//   Uses BlocBuilder with listenWhen to rebuild only on list state changes.
//   Action states (success/error) are handled in checkins_screen.dart via BlocListener.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/checkins_bloc.dart';
import 'checkin_member_card.dart';

class CheckinsList extends StatelessWidget {
  const CheckinsList({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;

    return BlocBuilder<CheckinsBloc, CheckinsState>(
      // Rebuild ONLY when the list data changes; not for action success/error.
      buildWhen: (prev, curr) =>
      curr is CheckinsLoading ||
          curr is CheckinsLoaded  ||
          curr is CheckinsError   ||
          curr is CheckinsInitial,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.checkins_todayTitle,
                style: TextStyle(
                  fontSize:   16,
                  fontWeight: FontWeight.w700,
                  color:      c.label,
                ),
              ),
            ),

            // ── List body ──────────────────────────────────────────────────
            if (state is CheckinsLoading || state is CheckinsInitial)
              _Skeleton()
            else if (state is CheckinsError)
              _ErrorView(message: state.message, colors: c)
            else if (state is CheckinsLoaded && state.checkins.isEmpty)
                _EmptyView(label: l10n.checkins_noCheckins, colors: c)
              else if (state is CheckinsLoaded)
                  ListView.builder(
                    // NeverScrollableScrollPhysics because the screen itself scrolls.
                    physics:     const NeverScrollableScrollPhysics(),
                    shrinkWrap:  true,
                    itemCount:   state.checkins.length,
                    itemBuilder: (_, i) =>
                        CheckinMemberCard(checkin: state.checkins[i]),
                  ),
          ],
        );
      },
    );
  }
}

// ── Skeleton (loading placeholder) ───────────────────────────────────────────
class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
            (i) => Container(
          margin:  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height:  100,
          decoration: BoxDecoration(
            color:        Colors.grey.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String  message;
  final dynamic colors;
  const _ErrorView({required this.message, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.error, fontSize: 14),
        ),
      ),
    );
  }
}

// ── Empty view ────────────────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  final String  label;
  final dynamic colors;
  const _EmptyView({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline_rounded,
                size: 48, color: colors.muted.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(color: colors.muted, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
