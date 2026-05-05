// FILE: lib/features/admin/staff/presentation/widgets/staff_card_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;

    // Derive role colors from primary/success/muted
    Color roleBadgeColor(String role) {
      switch (role.toLowerCase()) {
        case 'admin':
          return Color.lerp(c.primary, c.label, 0.3) ?? c.primary;
        case 'reception':
          return c.primary;
        case 'assistant':
          return Color.lerp(c.primary, c.success, 0.5) ?? c.primary;
        default:
          return c.muted;
      }
    }

    return BlocBuilder<AdminStaffBloc, AdminStaffState>(
      builder: (context, state) {
        final isLoading = state is StaffActionLoading &&
            state.staffId == staff.staffId;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              color:        c.surface,
              borderRadius: BorderRadius.circular(card.radius),
              boxShadow: [
                BoxShadow(
                  color:     Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset:    const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Top row: avatar + info + role badge ─────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius:          26,
                        backgroundColor: c.success,
                        child: Text(
                          _initials(staff.fullName),
                          style: TextStyle(
                            color:      c.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize:   16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    staff.fullName,
                                    style: TextStyle(
                                      fontSize:   16,
                                      fontWeight: FontWeight.bold,
                                      color:      c.label,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: roleBadgeColor(staff.roleName)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    staff.roleName,
                                    style: TextStyle(
                                      fontSize:   12,
                                      fontWeight: FontWeight.w600,
                                      color:      roleBadgeColor(staff.roleName),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            _buildInfoLine(icon: Icons.email_outlined, value: staff.email, color: c.muted),
                            const SizedBox(height: 4),
                            _buildInfoLine(icon: Icons.phone_outlined, value: staff.phone, color: c.muted),
                            const SizedBox(height: 4),
                            _buildInfoLine(icon: Icons.location_on_outlined, value: staff.branchName, color: c.muted),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Action buttons ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _openEditSheet(context),
                          icon: isLoading
                              ? SizedBox(
                            width:  14,
                            height: 14,
                            child:  CircularProgressIndicator(
                                strokeWidth: 2, color: c.primary),
                          )
                              : const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c.label,
                            side: BorderSide(
                                color: c.border.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            textStyle: const TextStyle(
                              fontSize:   13,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _confirmRemove(context),
                          icon: isLoading
                              ? SizedBox(
                            width:  14,
                            height: 14,
                            child:  CircularProgressIndicator(
                                strokeWidth: 2, color: c.danger),
                          )
                              : const Icon(Icons.block_outlined, size: 16),
                          label: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c.danger,
                            side:            BorderSide(color: c.danger),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            textStyle: const TextStyle(
                              fontSize:   13,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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

  // ignore: unused_element
  Widget _buildInfoLine2(IconData icon, String value, Color color) =>
      _buildInfoLine(icon: icon, value: value, color: color);

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminStaffBloc>(),
        child: AddEditStaffBottomSheet(existingStaff: staff),
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final bloc   = context.read<AdminStaffBloc>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:   const Text('Remove Staff Member'),
        content: Text(
          'Are you sure you want to remove ${staff.fullName}? '
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:     const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              bloc.add(StaffRemoveRequested(staff.staffId));
            },
            style: TextButton.styleFrom(foregroundColor: c.danger),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}