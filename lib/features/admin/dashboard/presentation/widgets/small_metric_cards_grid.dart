import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class SmallMetricCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;

  const SmallMetricCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SmallMetricCard(
                  icon: Icons.directions_run_rounded,
                  iconColor: const Color(0xFF3B82F6),
                  iconBg: const Color(0xFFEFF6FF),
                  value: '${data.checkins.attendanceCount}',
                  label: 'Attendance',
                  badge: '+${data.checkins.attendanceGrowth.toStringAsFixed(0)}%',
                  badgeColor: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SmallMetricCard(
                  icon: Icons.attach_money_rounded,
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFF0FDF4),
                  value: data.revenue != null
                      ? '₹${data.revenue!.paymentsCollected.toStringAsFixed(0)}'
                      : 'N/A',
                  label: 'Payments Collected',
                  badge: data.revenue != null
                      ? '+${data.revenue!.paymentsGrowth.toStringAsFixed(0)}%'
                      : null,
                  badgeColor: const Color(0xFF16A34A),
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
                  icon: Icons.calendar_month_outlined,
                  iconColor: const Color(0xFFF97316),
                  iconBg: const Color(0xFFFFF7ED),
                  value: '${data.members.expiringPlansNext7Days}',
                  label: 'Expiring Plans',
                  sublabel: 'Next 7 days',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SmallMetricCard(
                  icon: Icons.people_outline_rounded,
                  iconColor: const Color(0xFF9333EA),
                  iconBg: const Color(0xFFFAF5FF),
                  value: '${data.members.totalMembers}',
                  label: 'Total Members',
                  badge: '~${data.members.activeMembers} Active',
                  badgeColor: const Color(0xFF16A34A),
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
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String? badge;
  final Color? badgeColor;
  final String? sublabel;

  const _SmallMetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.badge,
    this.badgeColor,
    this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (sublabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  sublabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFD1D5DB),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: (badgeColor ?? const Color(0xFF16A34A)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 9,
                    color: badgeColor ?? const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    badge!,
                    style: TextStyle(
                      color: badgeColor ?? const Color(0xFF16A34A),
                      fontSize: 9,
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