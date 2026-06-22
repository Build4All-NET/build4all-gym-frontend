import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_stats_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class ExpenseStatsCardWidget extends StatelessWidget {
  final ExpenseStatsEntity stats;
  const ExpenseStatsCardWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;
    final l10n   = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _StatCard(
            value:      '₹${stats.totalThisMonth.toStringAsFixed(0)}',
            label:      l10n.admin_expenses_thisMonth,
            valueColor: c.primary,
            surface:    c.surface,
            cardRadius: card.radius,
          ),
          const SizedBox(width: 10),
          _StatCard(
            value:      '₹${stats.totalAllTime.toStringAsFixed(0)}',
            label:      l10n.admin_expenses_allTime,
            valueColor: c.danger,
            surface:    c.surface,
            cardRadius: card.radius,
          ),
          const SizedBox(width: 10),
          _StatCard(
            value:      stats.countThisMonth.toString(),
            label:      l10n.admin_expenses_entriesThisMonth,
            valueColor: c.success,
            surface:    c.surface,
            cardRadius: card.radius,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color  valueColor;
  final Color  surface;
  final double cardRadius;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.surface,
    required this.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color:        surface,
          borderRadius: BorderRadius.circular(cardRadius),
          boxShadow: [
            BoxShadow(
              color:     Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset:    const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize:   22,
                  fontWeight: FontWeight.w700,
                  color:      valueColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                  fontSize:   12,
                  color:      c.muted,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
