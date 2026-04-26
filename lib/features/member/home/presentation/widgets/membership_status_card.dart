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

    final status = membership.status.toLowerCase().trim();
    final showRenewButton = membership.canRenew || status == 'expired';

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
        children: [
          SizedBox(
            width: 116,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
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
                    size: 30,
                  ),
                ),
                const Spacer(),
                if (showRenewButton)
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.home_comingSoon),
                          backgroundColor: tokens.colors.primary,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spacing.lg,
                        vertical: tokens.spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.colors.onPrimary,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: tokens.colors.label.withOpacity(0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.home_renewNow,
                        style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.home_membershipStatus,
                  textAlign: TextAlign.end,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.onPrimary.withOpacity(0.82),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: tokens.spacing.sm),

                Text(
                  '✨ ${membership.planName}',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.headlineSmall.copyWith(
                    color: _planColor(tokens, status),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),

                const Spacer(),

                Text(
                  l10n.home_expiresOn,
                  textAlign: TextAlign.end,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary.withOpacity(0.82),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: tokens.spacing.xs),

                Text(
                  membership.expirationDate,
                  textAlign: TextAlign.end,
                  style: tokens.typography.titleMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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