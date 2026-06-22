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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              row.isLinked ? Icons.qr_code_scanner_rounded : Icons.fingerprint_rounded,
              color: statusColor,
              size: 20,
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
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: c.label)),
                const SizedBox(height: 3),
                Text(_formatType(row.employeeType),
                    style: TextStyle(fontSize: 12, color: c.muted)),
                const SizedBox(height: 2),
                Text(statusLabel, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: statusColor)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (row.isLinked)
            // Self check-in via QR scan — no manual buttons for the owner here.
            _PillBadge(label: l10n.admin_employees_selfCheckin, color: c.primary.withOpacity(0.10), textColor: c.primary)
          else if (isBusy)
            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          else if (row.isCheckedIn)
            OutlinedButton(
              onPressed: onCheckOut,
              style: OutlinedButton.styleFrom(
                foregroundColor: c.danger,
                side: BorderSide(color: c.danger),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: Text(l10n.admin_employees_checkOut, style: const TextStyle(fontSize: 12.5)),
            )
          else
            ElevatedButton(
              onPressed: onCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.success,
                foregroundColor: c.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: Text(l10n.admin_employees_checkIn, style: const TextStyle(fontSize: 12.5)),
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
