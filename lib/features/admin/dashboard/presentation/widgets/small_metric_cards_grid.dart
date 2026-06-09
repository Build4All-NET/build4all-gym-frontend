// FILE: lib/features/admin/dashboard/presentation/widgets/small_metric_cards_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_dashboard_summary.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class SmallMetricCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;
  const SmallMetricCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens     = context.read<ThemeCubit>().state.tokens;
    final c          = tokens.colors;
    final l10n       = AppLocalizations.of(context)!;
    final accentA    = c.primary;
    final accentB    = c.success;
    final accentC    = Color.lerp(c.danger, c.primary, 0.5) ?? c.primary;
    final accentD    = Color.lerp(c.primary, c.label, 0.3) ?? c.primary;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SmallMetricCard(
                  icon:       Icons.directions_run_rounded,
                  iconColor:  accentA,
                  iconBg:     accentA.withOpacity(0.1),
                  value:      '${data.checkins.attendanceCount}',
                  label:      l10n.admin_dashboard_attendance,
                  badge:      '+${data.checkins.attendanceGrowth.toStringAsFixed(0)}%',
                  badgeColor: accentB,
                  cardColor:  c.surface,
                  labelColor: c.muted,
                  valueColor: c.label,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SmallMetricCard(
                  icon:       Icons.attach_money_rounded,
                  iconColor:  accentB,
                  iconBg:     accentB.withOpacity(0.1),
                  value:      data.revenue != null
                      ? '₹${data.revenue!.paymentsCollected.toStringAsFixed(0)}'
                      : 'N/A',
                  label:      l10n.admin_dashboard_paymentsCollected,
                  badge:      data.revenue != null
                      ? '+${data.revenue!.paymentsGrowth.toStringAsFixed(0)}%'
                      : null,
                  badgeColor: accentB,
                  cardColor:  c.surface,
                  labelColor: c.muted,
                  valueColor: c.label,
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
                child: _SmallMetricCard(
                  icon:       Icons.calendar_month_outlined,
                  iconColor:  accentC,
                  iconBg:     accentC.withOpacity(0.1),
                  value:      '${data.members.expiringPlansNext7Days}',
                  label:      l10n.admin_dashboard_expiringPlans,
                  sublabel:   l10n.admin_dashboard_next7Days,
                  cardColor:  c.surface,
                  labelColor: c.muted,
                  valueColor: c.label,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SmallMetricCard(
                  icon:       Icons.people_outline_rounded,
                  iconColor:  accentD,
                  iconBg:     accentD.withOpacity(0.1),
                  value:      '${data.members.totalMembers}',
                  label:      l10n.admin_dashboard_totalMembers,
                  badge:      l10n.admin_dashboard_activeCount(data.members.activeMembers),
                  badgeColor: accentB,
                  cardColor:  c.surface,
                  labelColor: c.muted,
                  valueColor: c.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final Color    iconBg;
  final String   value;
  final String   label;
  final String?  badge;
  final Color?   badgeColor;
  final String?  sublabel;
  final Color    cardColor;
  final Color    labelColor;
  final Color    valueColor;

  const _SmallMetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.badge,
    this.badgeColor,
    this.sublabel,
    required this.cardColor,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width:   double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
                width:  36,
                height: 36,
                decoration: BoxDecoration(
                  color:        iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 10),
              Text(value,
                  style: TextStyle(
                      fontSize:   20,
                      fontWeight: FontWeight.w700,
                      color:      valueColor,
                      height:     1.1)),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize:   11,
                      color:      labelColor,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              if (sublabel != null) ...[
                const SizedBox(height: 2),
                Text(sublabel!,
                    style: TextStyle(
                        fontSize: 10,
                        color:    labelColor.withOpacity(0.6))),
              ],
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top:   10,
            right: 10,
            child: Container(
              padding:    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color:        (badgeColor ?? iconColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up_rounded,
                      size: 9, color: badgeColor ?? iconColor),
                  const SizedBox(width: 2),
                  Text(
                    badge!,
                    style: TextStyle(
                      color:      badgeColor ?? iconColor,
                      fontSize:   9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}