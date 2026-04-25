import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class LargeStatCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;
  const LargeStatCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _LargeStatCard(
              iconColor: const Color(0xFF3B82F6),
              icon: Icons.group,
              value: '${data.members.activeMembers}',
              sublabel: data.members.activeMembersGrowth >= 0
                  ? '+${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth'
                  : '${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth',
              sublabelColor: data.members.activeMembersGrowth >= 0
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFEF4444),
              title: 'Active Members',
            )),
            const SizedBox(width: 12),
            Expanded(child: _LargeStatCard(
              iconColor: const Color(0xFFF97316),
              icon: Icons.calendar_today,
              value: '${data.members.pendingRenewals}',
              sublabel: 'Due soon',
              sublabelColor: const Color(0xFFF97316),
              title: 'Pending Renewals',
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _LargeStatCard(
              iconColor: const Color(0xFF22C55E),
              icon: Icons.how_to_reg,
              value: '${data.checkins.todayCheckins}',
              sublabel: '↑ Live now',
              sublabelColor: const Color(0xFF22C55E),
              title: "Today's Check-ins",
            )),
            const SizedBox(width: 12),
            Expanded(child: _LargeStatCard(
              iconColor: const Color(0xFFA855F7),
              icon: Icons.fitness_center,
              value: '${data.checkins.upcomingPTSessions}',
              sublabel: 'Sessions',
              sublabelColor: const Color(0xFFA855F7),
              title: 'Upcoming PT',
            )),
          ],
        ),
      ],
    );
  }
}

class _LargeStatCard extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String value;
  final String title;
  final String sublabel;
  final Color sublabelColor;

  const _LargeStatCard({
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.title,
    required this.sublabel,
    required this.sublabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(sublabel, style: TextStyle(fontSize: 12, color: sublabelColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}