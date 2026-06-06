// FILE: lib/features/admin/dashboard/presentation/widgets/text_metric_rows.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_dashboard_summary.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class TextMetricRows extends StatelessWidget {
  final AdminDashboardSummary data;
  const TextMetricRows({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens        = context.read<ThemeCubit>().state.tokens;
    final c             = tokens.colors;
    final card          = tokens.card;
    final l10n          = AppLocalizations.of(context)!;
    final churnVsLast   = data.members.churnRateVsLastMonth;
    final revenueVsLast = data.revenue?.monthlyRevenueVsLastMonth;
    final accentD       = Color.lerp(c.primary, c.label, 0.3) ?? c.primary;

    return Container(
      decoration: BoxDecoration(
        color:        c.surface,
        borderRadius: BorderRadius.circular(card.radius),
        boxShadow: [
          BoxShadow(
            color:     Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset:    const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _TextMetricRow(
            label:          l10n.admin_dashboard_totalPlans,
            value:          '${data.plans.totalPlans}',
            dotColor:       c.primary,
            sublabel:       l10n.admin_dashboard_activeCount(data.plans.activePlans),
            sublabelColor:  c.primary,
            isFirst:        true,
            labelColor:     c.muted,
            valueColor:     c.label,
          ),
          _Divider(color: c.border.withOpacity(0.1)),
          _TextMetricRow(
            label:         l10n.admin_dashboard_canceled,
            value:         '${data.members.canceledLast7Days}',
            dotColor:      c.danger,
            sublabel:      l10n.admin_dashboard_last7Days,
            sublabelColor: c.muted,
            labelColor:    c.muted,
            valueColor:    c.label,
          ),
          _Divider(color: c.border.withOpacity(0.1)),
          _TextMetricRow(
            label:         l10n.admin_dashboard_churnRate,
            value:         '${data.members.churnRate.toStringAsFixed(1)}%',
            dotColor:      c.success,
            sublabel:      churnVsLast <= 0
                ? '${churnVsLast.toStringAsFixed(1)}% vs last month'
                : '+${churnVsLast.toStringAsFixed(1)}% vs last month',
            sublabelColor: churnVsLast <= 0 ? c.success : c.danger,
            labelColor:    c.muted,
            valueColor:    c.label,
          ),
          _Divider(color: c.border.withOpacity(0.1)),
          _TextMetricRow(
            label:         l10n.admin_dashboard_monthlyRevenue,
            value:         data.revenue != null
                ? '₹${(data.revenue!.monthlyRevenue / 100000).toStringAsFixed(1)}L'
                : 'N/A',
            dotColor:      accentD,
            sublabel:      revenueVsLast != null
                ? '+${revenueVsLast.toStringAsFixed(0)}% vs last month'
                : null,
            sublabelColor: c.success,
            isLast:        true,
            labelColor:    c.muted,
            valueColor:    c.label,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height:    1,
      thickness: 1,
      color:     color,
      indent:    16,
      endIndent: 16,
    );
  }
}

class _TextMetricRow extends StatelessWidget {
  final String  label;
  final String  value;
  final Color   dotColor;
  final String? sublabel;
  final Color   sublabelColor;
  final bool    isFirst;
  final bool    isLast;
  final Color   labelColor;
  final Color   valueColor;

  const _TextMetricRow({
    required this.label,
    required this.value,
    required this.dotColor,
    this.sublabel,
    required this.sublabelColor,
    this.isFirst = false,
    this.isLast  = false,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 18 : 14,
        16,
        isLast  ? 18 : 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize:   12,
                      color:      labelColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize:   22,
                      fontWeight: FontWeight.w700,
                      color:      valueColor)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width:  8,
                height: 8,
                decoration: BoxDecoration(
                    color: dotColor, shape: BoxShape.circle),
              ),
              if (sublabel != null) ...[
                const SizedBox(height: 8),
                Text(sublabel!,
                    style: TextStyle(
                        fontSize:   11,
                        color:      sublabelColor,
                        fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}