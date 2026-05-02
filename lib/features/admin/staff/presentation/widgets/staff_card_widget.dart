// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/widgets/staff_card_widget.dart
//
// CARD STRUCTURE (matches Figma):
//   ┌──────────────────────────────────────────────┐
//   │  🟢 avatar   Name          [Role Badge]      │
//   │              ✉ email                         │
//   │              📞 phone                        │
//   │              📍 branch                       │
//   │  [✏ Edit Profile]    [🚫 Remove]             │
//   └──────────────────────────────────────────────┘
//
// AVATAR: Green circle with white initials (first letters of first + last name).
// ROLE BADGE: Light colored pill on top-right (blue for Reception, purple for Admin, etc.)
// ACTION LOADING: Per-card spinner on both buttons when this card's action is in progress.
// REMOVE CONFIRMATION: AlertDialog before dispatching StaffRemoveRequested.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_staff_card_entity.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';
import '../bloc/admin_staff_state.dart';
import 'add_edit_staff_bottom_sheet.dart';

class StaffCardWidget extends StatelessWidget {
  final AdminStaffCardEntity staff;

  const StaffCardWidget({super.key, required this.staff});

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  Color _roleBadgeColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFF7C3AED); // purple
      case 'reception':
        return const Color(0xFF2563EB); // blue
      case 'assistant':
        return const Color(0xFF0891B2); // cyan
      default:
        return const Color(0xFF64748B); // slate
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminStaffBloc, AdminStaffState>(
      builder: (context, state) {
        final isLoading = state is StaffActionLoading &&
            state.staffId == staff.staffId;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: avatar + info + role badge ──────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Green avatar circle
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFF16A34A),
                        child: Text(
                          _initials(staff.fullName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name + contact info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name + role badge on same row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    staff.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Role badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _roleBadgeColor(staff.roleName)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    staff.roleName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _roleBadgeColor(staff.roleName),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Email
                            _buildInfoLine(
                              icon: Icons.email_outlined,
                              value: staff.email,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(height: 4),
                            // Phone
                            _buildInfoLine(
                              icon: Icons.phone_outlined,
                              value: staff.phone,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(height: 4),
                            // Branch
                            _buildInfoLine(
                              icon: Icons.location_on_outlined,
                              value: staff.branchName,
                              color: const Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // ── Action buttons ───────────────────────────────────────
                  Row(
                    children: [
                      // Edit Profile button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _openEditSheet(context),
                          icon: isLoading
                              ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          )
                              : const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E293B),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Remove button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _confirmRemove(context),
                          icon: isLoading
                              ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFDC2626),
                            ),
                          )
                              : const Icon(Icons.block_outlined, size: 16),
                          label: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFDC2626)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoLine({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminStaffBloc>(),
        child: AddEditStaffBottomSheet(existingStaff: staff),
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    final bloc = context.read<AdminStaffBloc>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Staff Member'),
        content: Text(
          'Are you sure you want to remove ${staff.fullName}? '
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              bloc.add(StaffRemoveRequested(staff.staffId));
            },
            style:
            TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}