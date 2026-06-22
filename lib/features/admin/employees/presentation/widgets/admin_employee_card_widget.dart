import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/employee_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminEmployeeCardWidget extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPay;
  final VoidCallback onViewHistory;
  final bool isDeleting;
  final bool isPaying;

  const AdminEmployeeCardWidget({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
    required this.onPay,
    required this.onViewHistory,
    this.isDeleting = false,
    this.isPaying = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final card = tokens.card;
    final l10n = AppLocalizations.of(context)!;

    final displayName = (employee.fullName == null || employee.fullName!.isEmpty)
        ? l10n.admin_employees_unknown
        : employee.fullName!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(card.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: name + salary ────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(displayName,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: c.label)),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${employee.salaryAmount.toStringAsFixed(2)} / ${_formatFrequency(employee.payFrequency, l10n)}',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: c.danger),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _PillBadge(
                  label: _formatType(employee.employeeType),
                  color: c.border.withOpacity(0.15),
                  textColor: c.muted,
                ),
                _PillBadge(
                  label: employee.branchName,
                  icon: Icons.store_outlined,
                  color: c.primary.withOpacity(0.10),
                  textColor: c.primary,
                ),
                if (!employee.isActive)
                  _PillBadge(
                    label: l10n.admin_employees_inactive,
                    icon: Icons.pause_circle_outline_rounded,
                    color: c.border.withOpacity(0.15),
                    textColor: c.muted,
                  ),
                if (employee.isLinked)
                  _PillBadge(
                    label: l10n.admin_employees_appAccount,
                    icon: Icons.verified_user_outlined,
                    color: c.success.withOpacity(0.10),
                    textColor: c.success,
                  ),
                _PillBadge(
                  label: l10n.admin_employees_daysThisMonth(employee.daysWorkedThisMonth),
                  icon: Icons.fingerprint_outlined,
                  color: c.primary.withOpacity(0.10),
                  textColor: c.primary,
                ),
                _dueBadge(c, l10n),
              ],
            ),

            const SizedBox(height: 6),
            GestureDetector(
              onTap: onViewHistory,
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 13, color: c.muted),
                  const SizedBox(width: 4),
                  Text(
                    employee.lastPaidDate != null
                        ? l10n.admin_employees_lastPaid(DateFormat('dd MMM yyyy').format(employee.lastPaidDate!))
                        : l10n.admin_employees_neverPaid,
                    style: TextStyle(fontSize: 12, color: c.muted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: c.border.withOpacity(0.15)),
            const SizedBox(height: 12),

            // ── Action buttons ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: Text(l10n.admin_employees_edit, style: const TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: c.body,
                      side: BorderSide(color: c.border.withOpacity(0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isDeleting ? null : onDelete,
                    icon: isDeleting
                        ? SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2, color: c.danger),
                          )
                        : const Icon(Icons.delete_outline_rounded, size: 15),
                    label: Text(isDeleting ? l10n.admin_employees_removing : l10n.admin_employees_remove,
                        style: const TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: c.danger,
                      side: BorderSide(color: c.danger),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isPaying ? null : onPay,
                icon: isPaying
                    ? SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2, color: c.onPrimary),
                      )
                    : const Icon(Icons.payments_outlined, size: 16),
                label: Text(
                  isPaying ? l10n.admin_employees_paying : l10n.admin_employees_pay,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: employee.isOverdue ? Colors.orange.shade700 : c.success,
                  foregroundColor: c.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dueBadge(ColorTokens c, AppLocalizations l10n) {
    switch (employee.dueStatus) {
      case 'OVERDUE':
        return _PillBadge(
          label: l10n.admin_employees_overdue,
          icon: Icons.warning_amber_rounded,
          color: c.danger.withOpacity(0.10),
          textColor: c.danger,
        );
      case 'DUE_SOON':
        return _PillBadge(
          label: l10n.admin_employees_dueSoon,
          icon: Icons.schedule_rounded,
          color: Colors.orange.withOpacity(0.12),
          textColor: Colors.orange.shade800,
        );
      default:
        return _PillBadge(
          label: l10n.admin_employees_upToDate,
          icon: Icons.check_circle_outline_rounded,
          color: c.success.withOpacity(0.10),
          textColor: c.success,
        );
    }
  }

  String _formatType(String type) {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1);
  }

  String _formatFrequency(String frequency, AppLocalizations l10n) {
    switch (frequency.toUpperCase()) {
      case 'WEEKLY':
        return l10n.admin_employees_freqWeek;
      case 'DAILY':
        return l10n.admin_employees_freqDay;
      default:
        return l10n.admin_employees_freqMonth;
    }
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  const _PillBadge({
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(label,
              style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
