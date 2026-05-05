import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_stats_entity.dart';
class AccountProfileCardWidget extends StatelessWidget {
  final MemberAccountEntity account;

  const AccountProfileCardWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Column(
        children: [
          // ── Top row: name + photo ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isRtl) _buildPhoto(context, tokens),
              if (isRtl) SizedBox(width: tokens.spacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.fullName,
                      textAlign: isRtl ? TextAlign.end : TextAlign.start,
                      style: tokens.typography.titleMedium.copyWith(
                        color: tokens.colors.onPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    if (account.memberSince != null) ...[
                      SizedBox(height: tokens.spacing.xs),
                      Text(
                        l10n.accountMemberSince(account.memberSince!),
                        textAlign: isRtl ? TextAlign.end : TextAlign.start,
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.onPrimary.withOpacity(0.85),
                        ),
                      ),
                    ],
                    if (account.planName != null) ...[
                      SizedBox(height: tokens.spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: tokens.colors.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              color: tokens.colors.onPrimary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              account.planName!,
                              style: tokens.typography.bodySmall.copyWith(
                                color: tokens.colors.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (!isRtl) SizedBox(width: tokens.spacing.md),
              if (!isRtl) _buildPhoto(context, tokens),
            ],
          ),

          // ── Divider ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: tokens.spacing.md),
            child: Divider(
              color: tokens.colors.onPrimary.withOpacity(0.2),
              height: 1,
            ),
          ),

          // ── Stats row — only sessions + exercises ──────────────────
          AccountStatsRowWidget(stats: account.stats),
        ],
      ),
    );
  }

  Widget _buildPhoto(BuildContext context, dynamic tokens) {
    return Stack(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tokens.colors.onPrimary.withOpacity(0.2),
            border: Border.all(color: tokens.colors.onPrimary, width: 2),
          ),
          child: account.profileFileId != null
              ? ClipOval(
            child: Image.network(
              'http://localhost:8080/api/files/${account.profileFileId}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.person,
                color: tokens.colors.onPrimary,
                size: 36,
              ),
            ),
          )
              : Icon(Icons.person, color: tokens.colors.onPrimary, size: 36),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: tokens.colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: tokens.colors.primary, width: 1.5),
            ),
            child: Icon(Icons.edit_rounded, size: 13, color: tokens.colors.primary),
          ),
        ),
      ],
    );
  }
}

// ── AccountStatsRowWidget ─────────────────────────────────────────────────────
// Receives MemberAccountStatsEntity — only sessions + exercises, no achievements.
class AccountStatsRowWidget extends StatelessWidget {
  final MemberAccountStatsEntity stats;

  const AccountStatsRowWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _StatItem(
          icon: Icons.trending_up_rounded,
          value: '${stats.exercisesCount}',
          label: l10n.accountStatExercises,
        ),
        _StatDivider(),
        _StatItem(
          icon: Icons.calendar_today_rounded,
          value: '${stats.sessionsCount}',
          label: l10n.accountStatSessions,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: tokens.colors.onPrimary, size: 22),
          SizedBox(height: tokens.spacing.xs),
          Text(
            value,
            style: tokens.typography.titleMedium.copyWith(
              color: tokens.colors.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: tokens.spacing.xs),
          Text(
            label,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.onPrimary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    return Container(
      width: 1,
      height: 40,
      color: tokens.colors.onPrimary.withOpacity(0.3),
    );
  }
}