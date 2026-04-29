import 'package:flutter/material.dart';
import '../../domain/entities/admin_plan_stats_entity.dart';

/// Renders the 3 stats cards: Total Plans | Members | Active
class PlanStatsCardWidget extends StatelessWidget {
  final AdminPlanStatsEntity stats;

  const PlanStatsCardWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _StatCard(
            value: stats.totalPlans.toString(),
            label: 'Total Plans',
            valueColor: const Color(0xFF2196F3), // blue
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: stats.totalMembers.toString(),
            label: 'Members',
            valueColor: const Color(0xFF4CAF50), // green
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: stats.activePlans.toString(),
            label: 'Active',
            valueColor: const Color(0xFF2196F3), // blue
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
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
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}