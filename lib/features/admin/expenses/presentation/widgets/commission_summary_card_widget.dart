// FILE: lib/features/admin/expenses/presentation/widgets/commission_summary_card_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

/// Shown when the "Commission" category filter is active. Summarizes the
/// (optionally trainer-filtered) commission rows into total / already-paid /
/// still-owed amounts so the owner can see what's left to pay a trainer.
class CommissionSummaryCardWidget extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  final String? trainerName;

  const CommissionSummaryCardWidget({
    super.key,
    required this.expenses,
    this.trainerName,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final card = tokens.card;
    final l10n = AppLocalizations.of(context)!;

    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final paid = expenses
        .where((e) => e.trainerPaid)
        .fold<double>(0, (sum, e) => sum + e.amount);
    final remaining = total - paid;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(card.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trainerName != null
                ? l10n.admin_expenses_commissionForTrainer(trainerName!)
                : l10n.admin_expenses_commissionAllTrainers,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: c.label,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _CommissionStat(
                label: l10n.admin_expenses_total,
                value: total,
                valueColor: c.primary,
                mutedColor: c.muted,
              ),
              _CommissionStat(
                label: l10n.admin_expenses_paid,
                value: paid,
                valueColor: c.success,
                mutedColor: c.muted,
              ),
              _CommissionStat(
                label: l10n.admin_expenses_remaining,
                value: remaining,
                valueColor: Colors.orange.shade800,
                mutedColor: c.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommissionStat extends StatelessWidget {
  final String label;
  final double value;
  final Color valueColor;
  final Color mutedColor;

  const _CommissionStat({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: mutedColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
