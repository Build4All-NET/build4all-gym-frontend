// =============================================================================
// FILE: member_info_section_widget.dart
// PATH: lib/features/admin/members/presentation/widgets/member_info_section_widget.dart
// TASK: GA-271
// =============================================================================

import 'package:flutter/material.dart';

import '../../domain/entities/member_detail_entity.dart';

class MemberInfoSectionWidget extends StatelessWidget {
  const MemberInfoSectionWidget({super.key, required this.member});

  final MemberDetailEntity member;

  static const _avatarColors = [
    Color(0xFF7C3AED),
    Color(0xFF2563EB),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFFDC2626),
  ];

  Color get _avatarColor =>
      _avatarColors[member.userId % _avatarColors.length];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // ── Avatar ────────────────────────────────────────────────────────
          CircleAvatar(
            radius: 40,
            backgroundColor: _avatarColor,
            child: Text(
              member.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Name ──────────────────────────────────────────────────────────
          Text(
            member.fullName ?? '—',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // ── Status badge ──────────────────────────────────────────────────
          _StatusBadge(status: member.membershipStatus ?? ''),
          const SizedBox(height: 20),

          // ── Info rows ─────────────────────────────────────────────────────
          _InfoRow(
            icon:  Icons.phone_outlined,
            label: member.phone ?? '—',
            cs:    cs,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon:  Icons.fitness_center_outlined,
            label: member.trainingType ?? '—',
            cs:    cs,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon:  Icons.person_outline,
            label: _capitalise(member.gender),
            cs:    cs,
          ),
        ],
      ),
    );
  }

  String _capitalise(String? value) {
    if (value == null || value.isEmpty) return '—';
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.cs,
  });

  final IconData    icon;
  final String      label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: cs.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg, text;
    String label;

    switch (status.toLowerCase()) {
      case 'active':
        bg = const Color(0xFF052E16); text = const Color(0xFF4ADE80); label = 'Active';
      case 'pending':
        bg = const Color(0xFF431407); text = const Color(0xFFFB923C); label = 'Pending';
      case 'blocked':
        bg = const Color(0xFF450A0A); text = const Color(0xFFF87171); label = 'Blocked';
      default:
        bg = Theme.of(context).colorScheme.surfaceVariant;
        text = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
        label = status.isEmpty ? 'Inactive' : status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}