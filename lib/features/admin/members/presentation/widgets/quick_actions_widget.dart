// =============================================================================
// FILE: quick_actions_widget.dart
// PATH: lib/features/admin/members/presentation/widgets/quick_actions_widget.dart
// TASK: GA-272
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:url_launcher/url_launcher.dart'; // add url_launcher: ^6.3.0

import '../../domain/entities/member_detail_entity.dart';
import '../bloc/admin_members_bloc.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key, required this.member});

  final MemberDetailEntity member;

  @override
  Widget build(BuildContext context) {
    final cs   = Theme.of(context).colorScheme;
    final bloc = context.read<AdminMembersBloc>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          // 2×3 grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap:     true,
            physics:        const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
            childAspectRatio: 1.1,
            children: [
              _ActionButton(
                icon:    Icons.phone_outlined,
                label:   'Call',
                color:   cs.primary,
                onTap:   () => _launchPhone(context, member.phone),
              ),
              _ActionButton(
                icon:    Icons.chat_bubble_outline,
                label:   'WhatsApp',
                color:   const Color(0xFF25D366),
                onTap:   () => _launchWhatsApp(context, member.phone),
              ),
              _ActionButton(
                icon:    Icons.sms_outlined,
                label:   'SMS',
                color:   cs.tertiary,
                onTap:   () => _launchSms(context, member.phone),
              ),
              _ActionButton(
                icon:    Icons.person_outline,
                label:   'Attendance',
                color:   cs.primary,
                onTap:   () => _showComingSoon(context, 'Attendance'),
              ),
              _ActionButton(
                icon:    Icons.refresh_rounded,
                label:   'Renew',
                color:   const Color(0xFFF97316),
                onTap:   () => _showComingSoon(context, 'Renew Plan'),
              ),
              _ActionButton(
                icon:  member.isBlocked
                    ? Icons.lock_open_outlined
                    : Icons.block_outlined,
                label: member.isBlocked ? 'Unblock' : 'Block',
                color: member.isBlocked
                    ? const Color(0xFF10B981)
                    : cs.error,
                onTap: () => member.isBlocked
                    ? bloc.add(MemberUnblockRequested(member.userId))
                    : _showBlockDialog(context, bloc),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Launchers — url_launcher stubs until package is added
  // ---------------------------------------------------------------------------

  Future<void> _launchPhone(BuildContext context, String? phone) async {
    if (phone == null || phone.isEmpty) return;
    // final uri = Uri.parse('tel:$phone');
    // if (await canLaunchUrl(uri)) await launchUrl(uri);
    _showComingSoon(context, 'Call ($phone)');
  }

  Future<void> _launchWhatsApp(BuildContext context, String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    // final uri = Uri.parse('https://wa.me/$digits');
    // if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
    _showComingSoon(context, 'WhatsApp: wa.me/$digits');
  }

  Future<void> _launchSms(BuildContext context, String? phone) async {
    if (phone == null || phone.isEmpty) return;
    // final uri = Uri.parse('sms:$phone');
    // if (await canLaunchUrl(uri)) await launchUrl(uri);
    _showComingSoon(context, 'SMS ($phone)');
  }

  void _showBlockDialog(BuildContext context, AdminMembersBloc bloc) {
    final cs = Theme.of(context).colorScheme;
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text('Block Member', style: TextStyle(color: cs.onSurface)),
        content: TextField(
          controller: reasonController,
          style: TextStyle(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: 'Enter reason for blocking',
            hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.4)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: cs.outline)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(MemberBlockRequested(
                userId: member.userId,
                reason: reasonController.text.trim(),
              ));
            },
            child: Text('Block', style: TextStyle(color: cs.error)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$feature — coming soon'),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      duration: const Duration(seconds: 1),
    ));
  }
}

// ---------------------------------------------------------------------------
// Single action button — dark rounded square with icon + label
// ---------------------------------------------------------------------------
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData    icon;
  final String      label;
  final Color       color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color:    cs.onSurface.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}