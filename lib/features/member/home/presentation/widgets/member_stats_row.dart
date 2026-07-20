import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/member/home/domain/entities/member_stats.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class MemberStatsRow extends StatelessWidget {
  final MemberStats stats;

  const MemberStatsRow({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _StatsCard(
            icon: Icons.calendar_today_outlined,
            iconColor: tokens.colors.primary,
            value: stats.sessionsCount.toString(),
            label: l10n.home_sessions,
          ),
        ),
        SizedBox(width: tokens.spacing.md),
        Expanded(
          child: _StatsCard(
            icon: Icons.fitness_center_outlined,
            iconColor: tokens.colors.success,
            value: stats.workoutsCount.toString(),
            label: l10n.home_workouts,
          ),
        ),
        SizedBox(width: tokens.spacing.md),
        Expanded(
          child: _StatsCard(
            icon: Icons.event_available_outlined,
            iconColor: tokens.colors.danger,
            value: stats.upcomingCount.toString(),
            label: l10n.home_upcoming,
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatsCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      height: 128,
      padding: EdgeInsets.symmetric(
        vertical: tokens.spacing.lg,
        horizontal: tokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: tokens.card.showBorder
            ? Border.all(
          color: tokens.colors.border.withOpacity(0.12),
        )
            : null,
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 34,
          ),
          const Spacer(),
          Text(
            value,
            style: tokens.typography.headlineSmall.copyWith(
              color: tokens.colors.label,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          ),
          SizedBox(height: tokens.spacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}