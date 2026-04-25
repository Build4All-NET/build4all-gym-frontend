import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class TextMetricRows extends StatelessWidget {
  final AdminDashboardSummary data;
  const TextMetricRows({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final churnVsLast = data.members.churnRateVsLastMonth;
    final revenueVsLast = data.revenue?.monthlyRevenueVsLastMonth;

    return Column(
      children: [
        _TextMetricRow(
          label: 'Total Plans',
          value: '${data.plans.totalPlans}',
          dotColor: const Color(0xFF3B82F6),
          sublabel: '${data.plans.activePlans} Active',
          sublabelColor: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 10),
        _TextMetricRow(
          label: 'Canceled',
          value: '${data.members.canceledLast7Days}',
          dotColor: const Color(0xFFEF4444),
          sublabel: 'Last 7 days',
          sublabelColor: Colors.black45,
        ),
        const SizedBox(height: 10),
        _TextMetricRow(
          label: 'Churn Rate',
          value: '${data.members.churnRate.toStringAsFixed(1)}%',
          dotColor: const Color(0xFF22C55E),
          sublabel: churnVsLast <= 0
              ? '${churnVsLast.toStringAsFixed(1)}% vs last month'
              : '+${churnVsLast.toStringAsFixed(1)}% vs last month',
          sublabelColor: churnVsLast <= 0
              ? const Color(0xFF22C55E)
              : const Color(0xFFEF4444),
        ),
        const SizedBox(height: 10),
        _TextMetricRow(
          label: 'Monthly Revenue',
          value: data.revenue != null
              ? '₹${(data.revenue!.monthlyRevenue / 100000).toStringAsFixed(1)}L'
              : 'N/A',
          dotColor: const Color(0xFFA855F7),
          sublabel: revenueVsLast != null
              ? '+${revenueVsLast.toStringAsFixed(0)}% vs last month'
              : null,
          sublabelColor: const Color(0xFF22C55E),
        ),
      ],
    );
  }
}

class _TextMetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final String? sublabel;
  final Color sublabelColor;

  const _TextMetricRow({
    required this.label, required this.value,
    required this.dotColor, this.sublabel,
    required this.sublabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              if (sublabel != null) ...[
                const SizedBox(height: 6),
                Text(sublabel!, style: TextStyle(fontSize: 11, color: sublabelColor)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}