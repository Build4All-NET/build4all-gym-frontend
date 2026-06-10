// FILE: lib/features/admin/dashboard/presentation/widgets/large_stat_cards_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_dashboard_summary.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class LargeStatCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;
  const LargeStatCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;
    final l10n   = AppLocalizations.of(context)!;

    // Use theme-derived accent colors — primary for main stats, success/danger for growth
    final growthPositive = c.success;
    final growthNegative = c.danger;
    final pendingColor   = Color.lerp(c.danger, c.primary, 0.5) ?? c.primary;
    final checkColor     = c.success;
    final ptColor        = Color.lerp(c.primary, c.label, 0.3) ?? c.primary;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _LargeStatCard(
                  iconColor: c.primary,
                  iconBg:    c.primary.withOpacity(0.1),
                  icon:      Icons.group_outlined,
                  value:     '${data.members.activeMembers}',
                  sublabel:  data.members.activeMembersGrowth >= 0
                      ? '+${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth'
                      : '${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth',
                  sublabelColor: data.members.activeMembersGrowth >= 0
                      ? growthPositive
                      : growthNegative,
                  title:     l10n.admin_dashboard_activeMembers,
                  cardColor: c.surface,
                  titleColor: c.muted,
                  valueColor: c.label,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _LargeStatCard(
                  iconColor:     pendingColor,
                  iconBg:        pendingColor.withOpacity(0.1),
                  icon:          Icons.calendar_today_outlined,
                  value:         '${data.members.pendingRenewals}',
                  sublabel:      l10n.admin_dashboard_dueSoon,
                  sublabelColor: pendingColor,
                  title:         l10n.admin_dashboard_pendingRenewals,
                  cardColor:     c.surface,
                  titleColor:    c.muted,
                  valueColor:    c.label,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _LargeStatCard(
                  iconColor:     checkColor,
                  iconBg:        checkColor.withOpacity(0.1),
                  icon:          Icons.how_to_reg_outlined,
                  value:         '${data.checkins.todayCheckins}',
                  sublabel:      l10n.admin_dashboard_liveNow,
                  sublabelColor: checkColor,
                  title:         l10n.admin_dashboard_todayCheckins,
                  cardColor:     c.surface,
                  titleColor:    c.muted,
                  valueColor:    c.label,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _LargeStatCard(
                  iconColor:     ptColor,
                  iconBg:        ptColor.withOpacity(0.1),
                  icon:          Icons.fitness_center_outlined,
                  value:         '${data.checkins.upcomingPTSessions}',
                  sublabel:      l10n.admin_dashboard_sessions,
                  sublabelColor: ptColor,
                  title:         l10n.admin_dashboard_upcomingPt,
                  cardColor:     c.surface,
                  titleColor:    c.muted,
                  valueColor:    c.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeStatCard extends StatelessWidget {
  final Color   iconColor;
  final Color   iconBg;
  final IconData icon;
  final String  value;
  final String  title;
  final String  sublabel;
  final Color   sublabelColor;
  final Color   cardColor;
  final Color   titleColor;
  final Color   valueColor;

  const _LargeStatCard({
    required this.iconColor,
    required this.iconBg,
    required this.icon,
    required this.value,
    required this.title,
    required this.sublabel,
    required this.sublabelColor,
    required this.cardColor,
    required this.titleColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:     Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset:    const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:       MainAxisSize.min,
        children: [
          Container(
            width:  44,
            height: 44,
            decoration: BoxDecoration(
              color:        iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(
                  fontSize:   12,
                  color:      titleColor,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  fontSize:   26,
                  fontWeight: FontWeight.w700,
                  color:      valueColor,
                  height:     1.1)),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.trending_up_rounded,
                  size: 12, color: sublabelColor),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  sublabel,
                  style: TextStyle(
                      fontSize:   11,
                      color:      sublabelColor,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}