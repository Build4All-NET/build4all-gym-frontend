import 'package:flutter/material.dart';
import '../../domain/entities/recent_activity_item.dart';

class RecentActivityFeed extends StatelessWidget {
  final List<RecentActivityItem> activities;
  const RecentActivityFeed({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {},
                child: const Text('View all', style: TextStyle(fontSize: 13, color: Color(0xFF3B82F6))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (activities.isEmpty)
            const Center(child: Text('No recent activity', style: TextStyle(color: Colors.black38)))
          else
            ...activities.map((item) => _ActivityItem(item: item)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivityItem item;
  const _ActivityItem({required this.item});

  Color _colorForType(String type) {
    switch (type) {
      case 'JOIN': return const Color(0xFF3B82F6);
      case 'RENEWAL': return const Color(0xFF22C55E);
      case 'PAYMENT': return const Color(0xFFA855F7);
      case 'CHECKIN': return const Color(0xFFF97316);
      default: return Colors.grey;
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'JOIN': return Icons.person_add;
      case 'RENEWAL': return Icons.autorenew;
      case 'PAYMENT': return Icons.attach_money;
      case 'CHECKIN': return Icons.directions_run;
      default: return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(item.activityType);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(_iconForType(item.activityType), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.memberName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(item.description, style: const TextStyle(color: Colors.black45, fontSize: 12)),
              ],
            ),
          ),
          Text(item.timeAgo, style: const TextStyle(color: Colors.black38, fontSize: 11)),
        ],
      ),
    );
  }
}