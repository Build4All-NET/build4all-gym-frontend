import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class SmallMetricCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;
  const SmallMetricCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _SmallMetricCard(
              icon: Icons.directions_run,
              iconColor: const Color(0xFF3B82F6),
              value: '${data.checkins.attendanceCount}',
              label: 'Attendance',
              badge: '+${data.checkins.attendanceGrowth.toStringAsFixed(0)}%',
            )),
            const SizedBox(width: 12),
            Expanded(child: _SmallMetricCard(
              icon: Icons.attach_money,
              iconColor: const Color(0xFF22C55E),
              value: data.revenue != null
                  ? '₹${data.revenue!.paymentsCollected.toStringAsFixed(0)}'
                  : 'N/A',
              label: 'Payments Collected',
              badge: data.revenue != null
                  ? '+${data.revenue!.paymentsGrowth.toStringAsFixed(0)}%'
                  : null,
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _SmallMetricCard(
              icon: Icons.calendar_month,
              iconColor: const Color(0xFFF97316),
              value: '${data.members.expiringPlansNext7Days}',
              label: 'Expiring Plans',
              sublabel: 'Next 7 days',
            )),
            const SizedBox(width: 12),
            Expanded(child: _SmallMetricCard(
              icon: Icons.people,
              iconColor: const Color(0xFFA855F7),
              value: '${data.members.totalMembers}',
              label: 'Total Members',
              badge: '~${data.members.activeMembers} Active',
            )),
          ],
        ),
      ],
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? badge;
  final String? sublabel;

  const _SmallMetricCard({
    required this.icon, required this.iconColor,
    required this.value, required this.label,
    this.badge, this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
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
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              if (sublabel != null) ...[
                const SizedBox(height: 2),
                Text(sublabel!, style: const TextStyle(fontSize: 10, color: Colors.black38)),
              ],
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: 8, right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}