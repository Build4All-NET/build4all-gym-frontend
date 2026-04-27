import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class TextMetricRows extends StatelessWidget {
  final AdminDashboardSummary data;

  const TextMetricRows({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final churnVsLast = data.members.churnRateVsLastMonth;
    final revenueVsLast = data.revenue?.monthlyRevenueVsLastMonth;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _TextMetricRow(
            label: 'Total Plans',
            value: '${data.plans.totalPlans}',
            dotColor: const Color(0xFF3B82F6),
            sublabel: '${data.plans.activePlans} Active',
            sublabelColor: const Color(0xFF3B82F6),
            isFirst: true,
          ),
          const _Divider(),
          _TextMetricRow(
            label: 'Canceled',
            value: '${data.members.canceledLast7Days}',
            dotColor: const Color(0xFFDC2626),
            sublabel: 'Last 7 days',
            sublabelColor: const Color(0xFF9CA3AF),
          ),
          const _Divider(),
          _TextMetricRow(
            label: 'Churn Rate',
            value: '${data.members.churnRate.toStringAsFixed(1)}%',
            dotColor: const Color(0xFF16A34A),
            sublabel: churnVsLast <= 0
                ? '${churnVsLast.toStringAsFixed(1)}% vs last month'
                : '+${churnVsLast.toStringAsFixed(1)}% vs last month',
            sublabelColor: churnVsLast <= 0
                ? const Color(0xFF16A34A)
                : const Color(0xFFDC2626),
          ),
          const _Divider(),
          _TextMetricRow(
            label: 'Monthly Revenue',
            value: data.revenue != null
                ? '₹${(data.revenue!.monthlyRevenue / 100000).toStringAsFixed(1)}L'
                : 'N/A',
            dotColor: const Color(0xFF9333EA),
            sublabel: revenueVsLast != null
                ? '+${revenueVsLast.toStringAsFixed(0)}% vs last month'
                : null,
            sublabelColor: const Color(0xFF16A34A),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF9FAFB),
      indent: 16,
      endIndent: 16,
    );
  }
}

class _TextMetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final String? sublabel;
  final Color sublabelColor;
  final bool isFirst;
  final bool isLast;

  const _TextMetricRow({
    required this.label,
    required this.value,
    required this.dotColor,
    this.sublabel,
    required this.sublabelColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 18 : 14,
        16,
        isLast ? 18 : 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (sublabel != null) ...[
                const SizedBox(height: 8),
                Text(
                  sublabel!,
                  style: TextStyle(
                    fontSize: 11,
                    color: sublabelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}