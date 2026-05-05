// FILE: lib/features/admin/staff/presentation/widgets/staff_stats_row_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme_cubit.dart';

class StaffStatsRowWidget extends StatelessWidget {
  final int totalStaff;
  final int activeStaff;

  const StaffStatsRowWidget({
    super.key,
    required this.totalStaff,
    required this.activeStaff,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              iconData:            Icons.group,
              iconBackgroundColor: c.primary,
              iconForegroundColor: c.onPrimary,
              count:               totalStaff,
              label:               'Total Staff',
              surface:             c.surface,
              labelColor:          c.muted,
              valueColor:          c.label,
              cardRadius:          card.radius,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              iconData:            Icons.manage_accounts,
              iconBackgroundColor: c.success,
              iconForegroundColor: c.onPrimary,
              count:               activeStaff,
              label:               'Active',
              surface:             c.surface,
              labelColor:          c.muted,
              valueColor:          c.label,
              cardRadius:          card.radius,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData iconData;
  final Color    iconBackgroundColor;
  final Color    iconForegroundColor;
  final int      count;
  final String   label;
  final Color    surface;
  final Color    labelColor;
  final Color    valueColor;
  final double   cardRadius;

  const _StatCard({
    required this.iconData,
    required this.iconBackgroundColor,
    required this.iconForegroundColor,
    required this.count,
    required this.label,
    required this.surface,
    required this.labelColor,
    required this.valueColor,
    required this.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        surface,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color:     Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset:    const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width:  44,
            height: 44,
            decoration: BoxDecoration(
              color:        iconBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: iconForegroundColor, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                    fontSize:   22,
                    fontWeight: FontWeight.bold,
                    color:      valueColor),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: labelColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}