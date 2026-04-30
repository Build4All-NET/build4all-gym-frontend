import 'package:build4allgym/app/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_card_entity.dart';
import '../bloc/admin_members_bloc.dart';

class MemberCardWidget extends StatelessWidget {
  final MemberCardEntity member;
  const MemberCardWidget({super.key, required this.member});

  // Avatar colors are intentional/decorative — not theme-driven.
  static const _avatarColors = [
    Color(0xFF7C3AED),
    Color(0xFF2563EB),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFFDC2626),
  ];

  Color get _avatarColor => _avatarColors[member.userId % _avatarColors.length];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      buildWhen: (prev, curr) {
        if (curr is MemberActionLoading && curr.userId == member.userId) return true;
        if (curr is MemberActionSuccess && curr.userId == member.userId) return true;
        if (curr is MemberActionError   && curr.userId == member.userId) return true;
        if (curr is MembersLoaded) return true;
        return false;
      },
      builder: (context, state) {
        final isLoading = state is MemberActionLoading && state.userId == member.userId;

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.memberDetail,
                  arguments: {
                    'userId': member.userId,
                    // Pass the bloc instance so the router can provide it
                    // to MemberDetailPage without needing its context.
                    'bloc': context.read<AdminMembersBloc>(),
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.surfaceVariant, // ← theme
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(cs),
                      const SizedBox(height: 12),
                      Divider(color: cs.outline.withOpacity(0.2), height: 1),
                      const SizedBox(height: 12),
                      _buildInfoGrid(cs),
                      const SizedBox(height: 12),
                      Divider(color: cs.outline.withOpacity(0.2), height: 1),
                      const SizedBox(height: 8),
                      _buildActionRow(context),
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay
            if (isLoading)
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: cs.primary, strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopRow(ColorScheme cs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: _avatarColor,
          child: Text(member.initials,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.fullName,
                  style: TextStyle(
                      color: cs.onSurface, fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 2),
              Text(member.memberCode,
                  style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12)),
              const SizedBox(height: 2),
              Text(member.phone,
                  style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ),
        _StatusBadge(status: member.membershipStatus ?? ''),
      ],
    );
  }

  Widget _buildInfoGrid(ColorScheme cs) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoLabel(label: 'Plan', cs: cs),
              _InfoValue(value: member.planName ?? '—', cs: cs),
              const SizedBox(height: 8),
              _InfoLabel(label: 'Due Amount', cs: cs),
              _InfoValue(
                value: '₹${(member.dueAmount ?? 0).toStringAsFixed(0)}',
                cs: cs,
                // Semantic red for dues — intentional, not theme-driven.
                overrideColor: member.hasDues ? const Color(0xFFEF4444) : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoLabel(label: 'Expiry', cs: cs),
              _InfoValue(value: member.expiryDate ?? '—', cs: cs),
              const SizedBox(height: 8),
              _InfoLabel(label: 'Branch', cs: cs),
              _InfoValue(value: member.branchName ?? '—', cs: cs),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final bloc = context.read<AdminMembersBloc>();
    final cs   = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // WhatsApp — semantic green, intentional
        _ActionIcon(
          icon: Icons.chat_bubble_outline,
          color: const Color(0xFF25D366),
          tooltip: 'WhatsApp',
          onTap: () => _launchWhatsApp(context),
        ),
        // Attendance
        _ActionIcon(
          icon: Icons.person_outline,
          color: cs.primary,
          tooltip: 'Attendance',
          onTap: () => _showComingSoon(context, 'Attendance'),
        ),
        // Renew
        _ActionIcon(
          icon: Icons.refresh,
          color: cs.tertiary,
          tooltip: 'Renew',
          onTap: () => _showComingSoon(context, 'Plan Renewal'),
        ),
        // Block / Unblock — semantic colors
        _ActionIcon(
          icon:  member.isBlocked ? Icons.lock_open_outlined : Icons.block,
          color: member.isBlocked ? const Color(0xFF10B981) : const Color(0xFFF97316),
          tooltip: member.isBlocked ? 'Unblock' : 'Block',
          onTap: () => member.isBlocked
              ? bloc.add(MemberUnblockRequested(member.userId))
              : _showBlockDialog(context, bloc),
        ),
        // Delete — semantic red
        _ActionIcon(
          icon:    Icons.delete_outline,
          color:   cs.error,
          tooltip: 'Delete',
          onTap:   () => _showDeleteConfirm(context, bloc),
        ),
        // Edit
        _ActionIcon(
          icon:    Icons.edit_outlined,
          color:   cs.onSurface.withOpacity(0.4),
          tooltip: 'Edit',
          onTap:   () => _showComingSoon(context, 'Edit Member'),
        ),
      ],
    );
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final digits = member.phone.replaceAll(RegExp(r'[^\d]'), '');
    // Uncomment after adding url_launcher:
    // final uri = Uri.parse('https://wa.me/$digits');
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri, mode: LaunchMode.externalApplication);
    // }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('WhatsApp: wa.me/$digits'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        duration: const Duration(seconds: 2),
      ));
    }
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
            child: Text('Cancel', style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(MemberBlockRequested(
                userId: member.userId,
                reason: reasonController.text.trim(),
              ));
            },
            child: const Text('Block', style: TextStyle(color: Color(0xFFF97316))),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, AdminMembersBloc bloc) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text('Delete Member', style: TextStyle(color: cs.onSurface)),
        content: Text(
          'Permanently delete ${member.fullName}? This cannot be undone.',
          style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(MemberDeleteRequested(member.userId));
            },
            child: Text('Delete', style: TextStyle(color: cs.error)),
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

// =============================================================================
// Helper widgets
// =============================================================================

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    // Status badge colors are semantic (green=active, red=blocked) —
    // intentionally NOT theme-driven so they stay universally readable.
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
        label = status.isEmpty ? 'No Plan' : status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  const _InfoLabel({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 11));
}

class _InfoValue extends StatelessWidget {
  final String value;
  final ColorScheme cs;
  final Color? overrideColor;
  const _InfoValue({required this.value, required this.cs, this.overrideColor});

  @override
  Widget build(BuildContext context) => Text(value,
      style: TextStyle(
        color: overrideColor ?? cs.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ));
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionIcon({
    required this.icon, required this.color,
    required this.tooltip, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 22),
      ),
    ),
  );
}