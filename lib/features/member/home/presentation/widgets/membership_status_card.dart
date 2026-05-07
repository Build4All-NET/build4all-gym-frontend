import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../domain/entities/membership_card.dart';

class MembershipStatusCard extends StatelessWidget {
  final MembershipCard membership;

  const MembershipStatusCard({
    super.key,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final status = membership.status.toLowerCase().trim();
    final showRenewButton = membership.canRenew || status == 'expired';
    final localizedPlanName = _localizedPlanName(membership.planName, status, l10n);

    final iconColumn = IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tokens.colors.danger.withOpacity(0.90),
                  tokens.colors.success.withOpacity(0.80),
                ],
              ),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: tokens.colors.onPrimary,
              size: 28,
            ),
          ),
          const Spacer(),
          if (showRenewButton)
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.comingSoon),
                    backgroundColor: tokens.colors.primary,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: tokens.colors.onPrimary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: tokens.colors.label.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.home_renewNow,
                    maxLines: 1,
                    softWrap: false,
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: isRtl ? 13 : 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    final textColumn = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          // RTL → stretch so TextAlign.right works | LTR → start as normal
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.home_membershipStatus,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              style: tokens.typography.bodySmall.copyWith(
                color: tokens.colors.onPrimary.withOpacity(0.82),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              localizedPlanName,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.headlineSmall.copyWith(
                color: _planColor(tokens, status),
                fontSize: 17,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
            Column(
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.home_expiresOn,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.onPrimary.withOpacity(0.82),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: tokens.spacing.xs),
                Text(
                  membership.expirationDate,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      height: 128,
      padding: EdgeInsets.all(tokens.spacing.md),
      decoration: BoxDecoration(
        color: tokens.colors.onPrimary.withOpacity(0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _borderColor(tokens, status),
          width: 1.2,
        ),
      ),
      child: Row(
        textDirection: TextDirection.ltr, // icon always LEFT
        children: [
          iconColumn,
          textColumn,
        ],
      ),
    );
  }

  String _localizedPlanName(
      String planName,
      String status,
      AppLocalizations l10n,
      ) {
    final normalized = planName.toLowerCase().trim();

    if (normalized.isEmpty ||
        normalized == 'no active membership' ||
        normalized == 'no membership' ||
        normalized == 'none') {
      return l10n.membershipStatusExpired;
    }

    switch (normalized) {
      case 'active':
        return l10n.membershipStatusActive;
      case 'frozen':
        return l10n.membershipStatusFrozen;
      case 'expired':
        return l10n.membershipStatusExpired;
      default:
        return planName;
    }
  }

  Color _planColor(dynamic tokens, String status) {
    switch (status) {
      case 'expired':
        return tokens.colors.danger;
      case 'frozen':
        return tokens.colors.onPrimary.withOpacity(0.75);
      case 'cancelled':
        return tokens.colors.muted;
      case 'active':
      default:
        return tokens.colors.onPrimary;
    }
  }

  Color _borderColor(dynamic tokens, String status) {
    switch (status) {
      case 'expired':
        return tokens.colors.danger.withOpacity(0.75);
      case 'frozen':
        return tokens.colors.onPrimary.withOpacity(0.35);
      case 'cancelled':
        return tokens.colors.muted.withOpacity(0.65);
      case 'active':
      default:
        return tokens.colors.onPrimary.withOpacity(0.28);
    }
  }
}
