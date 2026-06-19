import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/report_point_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';

/// A lightweight, dependency-free bar chart used by the Reports screen.
///
/// Responsive by design: bars have a fixed width and the row scrolls
/// horizontally when there are many points, so it reads well on any screen
/// size without overflowing. Heights are scaled to the largest value.
class ReportBarChartWidget extends StatelessWidget {
  const ReportBarChartWidget({
    super.key,
    required this.points,
    required this.emptyLabel,
    this.barColor,
    this.height = 160,
    this.valueFormatter,
  });

  final List<ReportPointEntity> points;
  final String emptyLabel;
  final Color? barColor;
  final double height;
  final String Function(double value)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final color = barColor ?? c.primary;

    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(emptyLabel,
              style: TextStyle(color: c.muted, fontSize: 13)),
        ),
      );
    }

    final maxValue = points
        .map((p) => p.value)
        .fold<double>(0, (a, b) => b > a ? b : a);
    final safeMax = maxValue <= 0 ? 1.0 : maxValue;
    final barAreaHeight = height - 38; // leave room for value + label

    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: points.map((p) {
            final ratio = (p.value / safeMax).clamp(0.0, 1.0);
            final barHeight = (barAreaHeight * ratio).clamp(2.0, barAreaHeight);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    valueFormatter?.call(p.value) ??
                        p.value.toStringAsFixed(0),
                    style: TextStyle(
                        fontSize: 9,
                        color: c.muted,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 22,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 34,
                    child: Text(
                      _shortLabel(p.label),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 9, color: c.muted),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// "2026-06-19" -> "06-19", otherwise leave as-is (e.g. category names).
  String _shortLabel(String label) {
    final parts = label.split('-');
    if (parts.length == 3) return '${parts[1]}-${parts[2]}';
    return label;
  }
}
