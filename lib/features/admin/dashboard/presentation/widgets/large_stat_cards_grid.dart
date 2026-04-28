import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class LargeStatCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;

  const LargeStatCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _LargeStatCard(
                  iconColor: const Color(0xFF3B82F6),
                  iconBg: const Color(0xFFEFF6FF),
                  icon: Icons.group_outlined,
                  value: '${data.members.activeMembers}',
                  sublabel: data.members.activeMembersGrowth >= 0
                      ? '+${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth'
                      : '${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth',
                  sublabelColor: data.members.activeMembersGrowth >= 0
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                  title: 'Active Members',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _LargeStatCard(
                  iconColor: const Color(0xFFF97316),
                  iconBg: const Color(0xFFFFF7ED),
                  icon: Icons.calendar_today_outlined,
                  value: '${data.members.pendingRenewals}',
                  sublabel: 'Due soon',
                  sublabelColor: const Color(0xFFF97316),
                  title: 'Pending Renewals',
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
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFF0FDF4),
                  icon: Icons.how_to_reg_outlined,
                  value: '${data.checkins.todayCheckins}',
                  sublabel: 'Live now',
                  sublabelColor: const Color(0xFF16A34A),
                  title: "Today's Check-ins",
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _LargeStatCard(
                  iconColor: const Color(0xFF9333EA),
                  iconBg: const Color(0xFFFAF5FF),
                  icon: Icons.fitness_center_outlined,
                  value: '${data.checkins.upcomingPTSessions}',
                  sublabel: 'Sessions',
                  sublabelColor: const Color(0xFF9333EA),
                  title: 'Upcoming PT',
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
  final Color iconColor;
  final Color iconBg;
  final IconData icon;
  final String value;
  final String title;
  final String sublabel;
  final Color sublabelColor;

  const _LargeStatCard({
    required this.iconColor,
    required this.iconBg,
    required this.icon,
    required this.value,
    required this.title,
    required this.sublabel,
    required this.sublabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container — fixed compact size
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          // Sublabel
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 12, color: sublabelColor),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: sublabelColor,
                    fontWeight: FontWeight.w600,
                  ),
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