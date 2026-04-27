import 'package:flutter/material.dart';
import '../../domain/entities/recent_activity_item.dart';

class RecentActivityFeed extends StatelessWidget {
  final List<RecentActivityItem> activities;

  const RecentActivityFeed({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (activities.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
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
            child: const Center(
              child: Text(
                'No recent activity',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          Container(
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
                for (int i = 0; i < activities.length; i++) ...[
                  _ActivityItem(
                    item: activities[i],
                    isFirst: i == 0,
                    isLast: i == activities.length - 1,
                  ),
                  if (i != activities.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF9FAFB),
                      indent: 62,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivityItem item;
  final bool isFirst;
  final bool isLast;

  const _ActivityItem({
    required this.item,
    this.isFirst = false,
    this.isLast = false,
  });

  Color _colorForType(String type) {
    switch (type.toUpperCase()) {
      case 'JOIN':
      case 'NEW_MEMBER':
        return const Color(0xFF3B82F6);
      case 'RENEWAL':
        return const Color(0xFF16A34A);
      case 'PAYMENT':
        return const Color(0xFF9333EA);
      case 'CHECKIN':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _bgForType(String type) {
    switch (type.toUpperCase()) {
      case 'JOIN':
      case 'NEW_MEMBER':
        return const Color(0xFFEFF6FF);
      case 'RENEWAL':
        return const Color(0xFFF0FDF4);
      case 'PAYMENT':
        return const Color(0xFFFAF5FF);
      case 'CHECKIN':
        return const Color(0xFFFFF7ED);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  IconData _iconForType(String type) {
    switch (type.toUpperCase()) {
      case 'JOIN':
      case 'NEW_MEMBER':
        return Icons.person_add_outlined;
      case 'RENEWAL':
        return Icons.autorenew_rounded;
      case 'PAYMENT':
        return Icons.attach_money_rounded;
      case 'CHECKIN':
        return Icons.directions_run_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(item.activityType);
    final bg = _bgForType(item.activityType);
    final icon = _iconForType(item.activityType);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 16 : 12,
        16,
        isLast ? 16 : 12,
      ),
      child: Row(
        children: [
          // Avatar with initials + activity icon overlay
          SizedBox(
            width: 42,
            height: 42,
            child: Stack(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _initialsFor(item.memberName),
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(icon, color: Colors.white, size: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.memberName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.timeAgo,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}