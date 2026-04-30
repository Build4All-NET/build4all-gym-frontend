// =============================================================================
// FILE: member_card_widget.dart
// LAYER: Presentation Layer → Widgets
// PURPOSE: Renders a single member's card in the list. Shows:
//           • Circular avatar with colored initials (or profile photo)
//           • Name, member code, phone, status badge (color-coded)
//           • 2-column info grid: Plan / Expiry | Due Amount (red if >0) / Branch
//           • Row of 6 action icon buttons: WhatsApp, Attendance, Renew,
//             Block/Unblock, Delete, Edit
//           • Per-card loading overlay when its action is in progress
//
// POSITION IN FLOW:
//   AdminMembersPage → ListView.builder → [this file] MemberCardWidget
//   User taps Block  → dispatches MemberBlockRequested to AdminMembersBloc
//   User taps Delete → dispatches MemberDeleteRequested to AdminMembersBloc
//   BLoC emits MemberActionLoading(userId) → this card shows a spinner
//   BLoC emits MemberActionSuccess         → card updates its status display
//
// RELATED FILES:
//   ← Receives:        MemberCardEntity (from MembersLoaded.members)
//   → Dispatches to:   admin_members_bloc.dart (block, delete, unblock events)
//   ← Reads state:     MemberActionLoading, MemberActionSuccess
//   ← Used by:         admin_members_page.dart (inside ListView.builder)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_card_entity.dart';
import '../bloc/admin_members_bloc.dart';

class MemberCardWidget extends StatelessWidget {
  final MemberCardEntity member;

  const MemberCardWidget({super.key, required this.member});

  // ---------------------------------------------------------------------------
  // Avatar background colors — cycled based on userId for visual variety.
  // ---------------------------------------------------------------------------
  static const _avatarColors = [
    Color(0xFF7C3AED), // purple
    Color(0xFF2563EB), // blue
    Color(0xFF059669), // green
    Color(0xFFD97706), // amber
    Color(0xFFDC2626), // red
  ];

  Color get _avatarColor =>
      _avatarColors[member.userId % _avatarColors.length];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      // buildWhen: only rebuild this card if an action state targets THIS userId,
      // or if the members list itself changes. Avoids rebuilding ALL cards.
      buildWhen: (prev, curr) {
        if (curr is MemberActionLoading && curr.userId == member.userId) {
          return true;
        }
        if (curr is MemberActionSuccess && curr.userId == member.userId) {
          return true;
        }
        if (curr is MemberActionError && curr.userId == member.userId) {
          return true;
        }
        if (curr is MembersLoaded) return true;
        return false;
      },
      builder: (context, state) {
        // Check if THIS card is currently performing an action.
        final isLoading =
            state is MemberActionLoading && state.userId == member.userId;

        return Stack(
          children: [
            // ----------------------------------------------------------------
            // Main card container — dark background with rounded corners.
            // ----------------------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- Top row: avatar + name/code/phone + status badge ----
                    _buildTopRow(),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFF2A2A2A), height: 1),
                    const SizedBox(height: 12),
                    // -- Info grid: Plan/Expiry, Due Amount/Branch ------------
                    _buildInfoGrid(),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFF2A2A2A), height: 1),
                    const SizedBox(height: 8),
                    // -- Action icons row ------------------------------------
                    _buildActionRow(context),
                  ],
                ),
              ),
            ),

            // ----------------------------------------------------------------
            // Loading overlay — shown on top of the card while an action runs.
            // Prevents the user from tapping other icons during the operation.
            // ----------------------------------------------------------------
            if (isLoading)
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C63FF),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Top section: avatar circle | name, code, phone | status badge.
  // ---------------------------------------------------------------------------
  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circular avatar with member initials.
        CircleAvatar(
          radius: 26,
          backgroundColor: _avatarColor,
          child: Text(
            member.initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Name, member code, phone — flexible to not overflow.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                member.memberCode,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                member.phone,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),

        // Status badge — color reflects membership status.
        _StatusBadge(status: member.membershipStatus),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2-column info grid: Plan | Expiry, Due Amount | Branch.
  // ---------------------------------------------------------------------------
  Widget _buildInfoGrid() {
    return Row(
      children: [
        // Left column: Plan name, Due Amount.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoLabel(label: 'Plan'),
              _InfoValue(value: member.planName),
              const SizedBox(height: 8),
              _InfoLabel(label: 'Due Amount'),
              _InfoValue(
                value: '₹${member.dueAmount.toStringAsFixed(0)}',
                // Red text if there are dues outstanding.
                color: member.hasDues ? const Color(0xFFEF4444) : Colors.white,
              ),
            ],
          ),
        ),

        // Right column: Expiry date, Branch.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoLabel(label: 'Expiry'),
              _InfoValue(value: member.expiryDate),
              const SizedBox(height: 8),
              _InfoLabel(label: 'Branch'),
              _InfoValue(value: member.branchName),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Row of 6 action icon buttons.
  // ---------------------------------------------------------------------------
  Widget _buildActionRow(BuildContext context) {
    final bloc = context.read<AdminMembersBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // 1. WhatsApp — opens chat (green)
        _ActionIcon(
          icon: Icons.chat_bubble_outline,
          color: const Color(0xFF25D366),
          tooltip: 'WhatsApp',
          onTap: () {
            // TODO: Launch WhatsApp deep-link with member.phone
          },
        ),

        // 2. Attendance — view/mark attendance (blue)
        _ActionIcon(
          icon: Icons.person_outline,
          color: const Color(0xFF3B82F6),
          tooltip: 'Attendance',
          onTap: () {
            // TODO: Navigate to attendance page for this member
          },
        ),

        // 3. Renew — renew membership (purple)
        _ActionIcon(
          icon: Icons.refresh,
          color: const Color(0xFF8B5CF6),
          tooltip: 'Renew',
          onTap: () {
            // TODO: Open renewal bottom sheet
          },
        ),

        // 4. Block / Unblock — toggles based on current status (orange/green)
        _ActionIcon(
          icon: member.isBlocked ? Icons.lock_open_outlined : Icons.block,
          color: member.isBlocked
              ? const Color(0xFF10B981) // green = unblock available
              : const Color(0xFFF97316), // orange = block available
          tooltip: member.isBlocked ? 'Unblock' : 'Block',
          onTap: () => member.isBlocked
              ? bloc.add(MemberUnblockRequested(member.userId))
              : _showBlockDialog(context, bloc),
        ),

        // 5. Delete — permanently removes member (red)
        _ActionIcon(
          icon: Icons.delete_outline,
          color: const Color(0xFFEF4444),
          tooltip: 'Delete',
          onTap: () => _showDeleteConfirm(context, bloc),
        ),

        // 6. Edit — open edit form (grey)
        _ActionIcon(
          icon: Icons.edit_outlined,
          color: Colors.grey,
          tooltip: 'Edit',
          onTap: () {
            // TODO: Navigate to edit member page
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Block dialog — asks admin for a reason before blocking.
  // ---------------------------------------------------------------------------
  void _showBlockDialog(BuildContext context, AdminMembersBloc bloc) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Block Member',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: reasonController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter reason for blocking',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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

  // ---------------------------------------------------------------------------
  // Delete confirmation dialog — prevents accidental deletes.
  // ---------------------------------------------------------------------------
  void _showDeleteConfirm(BuildContext context, AdminMembersBloc bloc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Member', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to permanently delete ${member.fullName}?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(MemberDeleteRequested(member.userId));
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Small private helper widgets — kept in this file since they're only used here.
// =============================================================================

/// Colored pill badge showing the member's status.
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status.toLowerCase()) {
      case 'active':
        bg = const Color(0xFF052E16);
        text = const Color(0xFF4ADE80);
        label = 'Active';
        break;
      case 'pending':
        bg = const Color(0xFF431407);
        text = const Color(0xFFFB923C);
        label = 'Pending';
        break;
      case 'blocked':
        bg = const Color(0xFF450A0A);
        text = const Color(0xFFF87171);
        label = 'Blocked';
        break;
      default:
        bg = const Color(0xFF1F2937);
        text = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Small grey label (e.g. "Plan", "Expiry").
class _InfoLabel extends StatelessWidget {
  final String label;

  const _InfoLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.grey, fontSize: 11),
    );
  }
}

/// Value text below the label (e.g. "HIIT Quarterly", "6/1/2026").
class _InfoValue extends StatelessWidget {
  final String value;
  final Color color;

  const _InfoValue({
    required this.value,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }
}

/// Tappable icon with tooltip — used in the action row.
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
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
}