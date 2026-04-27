import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onAddMember;
  final VoidCallback onRecordPayment;
  final VoidCallback onAddPlan;
  final VoidCallback onSendAnnouncement;

  const QuickActionsSection({
    super.key,
    required this.onAddMember,
    required this.onRecordPayment,
    required this.onAddPlan,
    required this.onSendAnnouncement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 14),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ),
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
              _ActionRow(
                icon: Icons.person_add_outlined,
                iconColor: const Color(0xFF3B82F6),
                iconBg: const Color(0xFFEFF6FF),
                label: 'Add Member',
                onTap: onAddMember,
                isFirst: true,
              ),
              const _RowDivider(),
              _ActionRow(
                icon: Icons.attach_money_rounded,
                iconColor: const Color(0xFF16A34A),
                iconBg: const Color(0xFFF0FDF4),
                label: 'Record Payment',
                onTap: onRecordPayment,
              ),
              const _RowDivider(),
              _ActionRow(
                icon: Icons.credit_card_outlined,
                iconColor: const Color(0xFF9333EA),
                iconBg: const Color(0xFFFAF5FF),
                label: 'Add Plan',
                onTap: onAddPlan,
              ),
              const _RowDivider(),
              _ActionRow(
                icon: Icons.send_outlined,
                iconColor: const Color(0xFFF97316),
                iconBg: const Color(0xFFFFF7ED),
                label: 'Send Announcement',
                onTap: onSendAnnouncement,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF9FAFB),
      indent: 62,
      endIndent: 0,
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}