import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/employee_checkin_row_entity.dart';

class EmployeeCheckinRowWidget extends StatelessWidget {
  final EmployeeCheckinRowEntity row;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final bool isBusy;

  const EmployeeCheckinRowWidget({
    super.key,
    required this.row,
    required this.onCheckIn,
    required this.onCheckOut,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final card = tokens.card;
    final l10n = AppLocalizations.of(context)!;

    final statusColor = switch (row.status) {
      'ACTIVE' => c.success,
      'CHECKED_OUT' => c.muted,
      _ => Colors.orange.shade800,
    };
    final statusLabel = switch (row.status) {
      'ACTIVE' => row.checkinTime != null
          ? l10n.admin_employees_checkedInAt(DateFormat('HH:mm').format(row.checkinTime!))
          : l10n.admin_employees_checkedIn,
      'CHECKED_OUT' => row.checkoutTime != null
          ? l10n.admin_employees_checkedOutAt(DateFormat('HH:mm').format(row.checkoutTime!))
          : l10n.admin_employees_checkedOut,
      _ => l10n.admin_employees_notCheckedIn,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(card.radius),
        boxShadow: tokens.card.showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: tokens.card.showBorder ? Border.all(color: c.border.withOpacity(0.15)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status accent bar — mirrors the member check-ins card language.
          Container(width: 4, color: statusColor.withOpacity(row.status == 'NOT_CHECKED_IN' ? 0.3 : 1)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: statusColor.withOpacity(0.12),
                    child: Icon(
                      row.isLinked ? Icons.qr_code_scanner_rounded : Icons.badge_outlined,
                      color: statusColor,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row.employeeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: c.label)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _TypeChip(label: _formatType(row.employeeType), colors: c),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 7, color: statusColor),
                                const SizedBox(width: 5),
                                Text(statusLabel,
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: statusColor)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (row.isLinked)
                    // Self check-in via QR scan — no manual buttons for the owner here.
                    _PillBadge(
                        label: l10n.admin_employees_selfCheckin,
                        color: c.primary.withOpacity(0.10),
                        textColor: c.primary)
                  else if (isBusy)
                    const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2))
                  else if (row.isCheckedIn)
                    _ActionButton(
                      icon: Icons.logout_rounded,
                      label: l10n.admin_employees_checkOut,
                      color: c.danger,
                      onTap: onCheckOut,
                    )
                  else
                    _ActionButton(
                      icon: Icons.login_rounded,
                      label: l10n.admin_employees_checkIn,
                      color: c.success,
                      onTap: onCheckIn,
                      filled: true,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatType(String type) {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1);
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final dynamic colors;
  const _TypeChip({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.muted.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: colors.muted, fontWeight: FontWeight.w600)),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _PillBadge({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Outlined/filled action button — mirrors CheckinMemberCard's button style ──
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 15, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          minimumSize: Size.zero,
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15, color: color),
      label: Text(label, style: TextStyle(fontSize: 12.5, color: color, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
