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
          const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ActionItem(icon: Icons.person_add, iconColor: const Color(0xFF3B82F6), label: 'Add Member', onTap: onAddMember),
          const Divider(height: 1),
          _ActionItem(icon: Icons.attach_money, iconColor: const Color(0xFF22C55E), label: 'Record Payment', onTap: onRecordPayment),
          const Divider(height: 1),
          _ActionItem(icon: Icons.credit_card, iconColor: const Color(0xFFA855F7), label: 'Add Plan', onTap: onAddPlan),
          const Divider(height: 1),
          _ActionItem(icon: Icons.send, iconColor: const Color(0xFFF97316), label: 'Send Announcement', onTap: onSendAnnouncement),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({required this.icon, required this.iconColor, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
    );
  }
}