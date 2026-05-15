import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

/// Small membership status badge shown at the top of the QR card.
///
/// No hardcoded UI text.
/// Text comes from ARB through AppLocalizations.
///
/// Backend status examples:
/// - ACTIVE
/// - EXPIRED
/// - CANCELLED
/// - FROZEN
/// - PENDING
/// - NO_MEMBERSHIP
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

    final isActive = membershipStatus.toUpperCase().trim() == 'ACTIVE';

    final badgeColor = isActive ? tokens.colors.success : tokens.colors.error;

    final label = isActive
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
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
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