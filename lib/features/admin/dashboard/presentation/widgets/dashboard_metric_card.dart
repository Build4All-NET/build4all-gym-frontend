// FILE: lib/features/admin/dashboard/presentation/widgets/dashboard_metric_card.dart
//
// A single dashboard metric card matching the gym admin design:
//   ┌──────────────────────────────┐
//   │ 0                  [icon]     │   ← value (top-left, colored) + icon (top-right)
//   │ Attendance              ›     │   ← label (bottom-left) + chevron (bottom-right)
//   └──────────────────────────────┘
//
// Uses the app's ThemeCubit tokens so it matches the rest of the admin UI.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme_cubit.dart';

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.valueColor,
    this.onTap,
    this.highlighted = false,
  });

  /// The big number / amount shown top-left (already formatted, e.g. "0", "₹50").
  final String value;

  /// The descriptive label shown bottom-left (e.g. "Attendance").
  final String label;

  /// Icon shown top-right.
  final IconData icon;

  /// Color of the value text. Defaults to the theme primary when null.
  /// Pass the danger token for "due / expiring" metrics (shown red in the design).
  final Color? valueColor;

  /// Optional tap handler — when null the chevron is hidden.
  final VoidCallback? onTap;

  /// When true the card gets a subtle tinted background + border (selected look).
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final vColor = valueColor ?? c.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlighted ? c.primary.withOpacity(0.06) : c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlighted
                ? c.primary.withOpacity(0.45)
                : c.border.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Top row: value + icon ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: vColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(icon, size: 20, color: c.primary),
              ],
            ),
            // ── Bottom row: label + chevron ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: c.label,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onTap != null)
                  Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      size: 18,
                      color: c.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
