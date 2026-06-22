import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/expense_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminExpenseCardWidget extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onConfirmTrainerPaid;
  final bool isDeleting;
  final bool isConfirmingTrainerPaid;

  const AdminExpenseCardWidget({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
    required this.onConfirmTrainerPaid,
    this.isDeleting = false,
    this.isConfirmingTrainerPaid = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final card = tokens.card;
    final l10n = AppLocalizations.of(context)!;

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
            // ── Top row: title + amount ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(expense.title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: c.label)),
                ),
                const SizedBox(width: 8),
                Text('₹${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: c.danger)),
              ],
            ),

            if (expense.description != null && expense.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(expense.description!,
                  style: TextStyle(fontSize: 13, color: c.body, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],

            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _PillBadge(
                  label: _formatCategory(expense.category),
                  color: c.border.withOpacity(0.15),
                  textColor: c.muted,
                ),
                _PillBadge(
                  label: expense.branchName,
                  icon: Icons.store_outlined,
                  color: c.primary.withOpacity(0.10),
                  textColor: c.primary,
                ),
                _PillBadge(
                  label: DateFormat('dd MMM yyyy').format(expense.expenseDate),
                  icon: Icons.calendar_today_outlined,
                  color: c.border.withOpacity(0.12),
                  textColor: c.body,
                ),
                if (expense.trainerName != null)
                  _PillBadge(
                    label: expense.trainerName!,
                    icon: Icons.fitness_center_rounded,
                    color: c.success.withOpacity(0.10),
                    textColor: c.success,
                  ),
                if (expense.isAutoRecorded)
                  _PillBadge(
                    label: l10n.admin_expenses_autoRecorded,
                    icon: Icons.bolt_rounded,
                    color: c.primary.withOpacity(0.10),
                    textColor: c.primary,
                  ),
                if (expense.isPendingTrainerPayout)
                  _PillBadge(
                    label: l10n.admin_expenses_pendingTrainerPayout,
                    icon: Icons.hourglass_top_rounded,
                    color: Colors.orange.withOpacity(0.12),
                    textColor: Colors.orange.shade800,
                  ),
              ],
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
                    label: Text(l10n.admin_plans_editAction, style: const TextStyle(fontSize: 13)),
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
                    label: Text(isDeleting ? l10n.admin_plans_deletingAction : l10n.admin_expenses_delete,
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

            if (expense.isPendingTrainerPayout) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isConfirmingTrainerPaid ? null : onConfirmTrainerPaid,
                  icon: isConfirmingTrainerPaid
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2, color: c.onPrimary),
                        )
                      : const Icon(Icons.check_circle_outline_rounded, size: 16),
                  label: Text(
                    isConfirmingTrainerPaid
                        ? l10n.admin_expenses_confirming
                        : l10n.admin_expenses_confirmPaidToTrainer,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: c.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCategory(String category) {
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1);
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
