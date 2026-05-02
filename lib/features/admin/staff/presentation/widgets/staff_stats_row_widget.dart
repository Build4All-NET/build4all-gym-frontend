// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/widgets/staff_stats_row_widget.dart
//
// Stateless — receives totalStaff and activeStaff directly from StaffLoaded.
// Both counts are branch-scoped, updated on every action reload.
//
// LAYOUT: Two equal-width cards in a Row using Expanded.
//   Card 1 (blue)  — person-group icon, totalStaff count, "Total Staff"
//   Card 2 (green) — person-settings icon, activeStaff count, "Active"
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class StaffStatsRowWidget extends StatelessWidget {
  final int totalStaff;
  final int activeStaff;

  const StaffStatsRowWidget({
    super.key,
    required this.totalStaff,
    required this.activeStaff,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // ── Total Staff Card ───────────────────────────────────────────────
          Expanded(
            child: _StatCard(
              iconData: Icons.group,
              iconBackgroundColor: const Color(0xFF2563EB), // primary blue
              count: totalStaff,
              label: 'Total Staff',
              // Replace with AppLocalizations: AppLocalizations.of(context)!.totalStaff
            ),
          ),
          const SizedBox(width: 12),
          // ── Active Staff Card ──────────────────────────────────────────────
          Expanded(
            child: _StatCard(
              iconData: Icons.manage_accounts,
              iconBackgroundColor: const Color(0xFF16A34A), // green
              count: activeStaff,
              label: 'Active',
              // Replace with AppLocalizations: AppLocalizations.of(context)!.active
            ),
          ),
        ],
      ),
    );
  }
}

/// Private helper — one stats card.
class _StatCard extends StatelessWidget {
  final IconData iconData;
  final Color iconBackgroundColor;
  final int count;
  final String label;

  const _StatCard({
    required this.iconData,
    required this.iconBackgroundColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coloured rounded-square icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}