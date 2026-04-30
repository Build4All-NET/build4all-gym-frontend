import 'package:flutter/material.dart';
import '../../domain/entities/admin_plan_stats_entity.dart';

class PlanStatsCardWidget extends StatelessWidget {
  final AdminPlanStatsEntity stats;

  const PlanStatsCardWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _StatCard(
            value: stats.totalPlans.toString(),
            label: 'Total Plans',
            valueColor: const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: stats.totalMembers.toString(),
            label: 'Members',
            valueColor: const Color(0xFF16A34A),
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: stats.activePlans.toString(),
            label: 'Active',
            valueColor: const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}