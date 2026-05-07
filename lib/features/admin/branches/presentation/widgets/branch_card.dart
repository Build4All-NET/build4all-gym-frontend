// ─────────────────────────────────────────────────────────────────────────────
// FILE: widgets/branch_card.dart
// One branch row in the scrollable list
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../domain/entity/branch_entity.dart';

class BranchCard extends StatelessWidget {
  final BranchEntity branch;
  final VoidCallback onTap;

  const BranchCard({super.key, required this.branch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: name + status badge ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    branch.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                _StatusBadge(isActive: branch.isActive),
              ],
            ),
            if (branch.city != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(branch.city!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // ── Stats row: Members / Trainers / Staff ───────────────────────
            Row(
              children: [
                _MiniStat(
                  icon: Icons.people_outline,
                  color: const Color(0xFF3B82F6),
                  label: '${branch.memberCount}',
                  sub: 'Members',
                ),
                const SizedBox(width: 12),
                _MiniStat(
                  icon: Icons.fitness_center,
                  color: const Color(0xFF8B5CF6),
                  label: '${branch.trainerCount}',
                  sub: 'Trainers',
                ),
                const SizedBox(width: 12),
                _MiniStat(
                  icon: Icons.manage_accounts_outlined,
                  color: const Color(0xFF10B981),
                  label: '${branch.staffCount}',
                  sub: 'Staff',
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // ── Footer row: hours + revenue ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (branch.openingTime != null && branch.closingTime != null)
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${branch.openingTime} - ${branch.closingTime}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                Text(
                  '₹${_formatRevenue(branch.monthlyRevenue)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatRevenue(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF10B981).withOpacity(0.12)
            : Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? const Color(0xFF10B981) : Colors.grey[600],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String sub;
  const _MiniStat(
      {required this.icon,
        required this.color,
        required this.label,
        required this.sub});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13, color: color)),
        const SizedBox(width: 3),
        Text(sub,
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}