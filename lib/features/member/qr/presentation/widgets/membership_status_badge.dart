import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

/// Small access status badge shown at the top of the QR card.
///
/// Backend status examples:
/// - SESSION
/// - ACTIVE
/// - EXPIRED
/// - CANCELLED
/// - FROZEN
/// - PENDING
/// - NO_MEMBERSHIP
/// - NO_ACTIVE_ACCESS
class MembershipStatusBadge extends StatelessWidget {
  final String membershipStatus;

  const MembershipStatusBadge({
    super.key,
    required this.membershipStatus,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final status = membershipStatus.toUpperCase().trim();

    /*
     * Valid access cases:
     * - ACTIVE: normal gym membership
     * - SESSION: booked class/session today
     */
    final hasAccess = status == 'ACTIVE' || status == 'SESSION';

    final badgeColor = hasAccess ? tokens.colors.success : tokens.colors.error;

    final icon = hasAccess
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;

    /*
     * We reuse existing localized strings to avoid ARB changes now.
     *
     * SESSION should be shown as valid access.
     * Later, you can add a specific ARB key:
     * memberQrSessionAccess = "Session access"
     */
    final label = hasAccess
        ? l10n.memberQrActiveMembership
        : l10n.memberQrInactiveMembership;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.md,
        vertical: tokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: badgeColor,
          ),
          SizedBox(width: tokens.spacing.xs),
          Text(
            label,
            style: tokens.typography.bodySmall.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}