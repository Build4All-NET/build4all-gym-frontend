import 'package:flutter/material.dart';

/// One filter item used inside the horizontal filter row.
class MemberInvoiceFilterItem {
  final String label;
  final String? value;
  final IconData icon;

  const MemberInvoiceFilterItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

/// Horizontal filter chips row.
///
/// Used twice:
/// - invoice status filters
/// - invoice type filters
class MemberInvoiceFilterChips extends StatelessWidget {
  final List<MemberInvoiceFilterItem> filters;
  final String? selectedValue;
  final dynamic tokens;
  final Color activeColor;
  final void Function(String?) onSelect;

  const MemberInvoiceFilterChips({
    super.key,
    required this.filters,
    required this.selectedValue,
    required this.tokens,
    required this.activeColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final filter = filters[index];
          final selected = filter.value == selectedValue;

          return GestureDetector(
            onTap: () => onSelect(filter.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? activeColor : c.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? activeColor
                      : c.border.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 14.0,
                    color: selected ? c.onPrimary : c.muted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    filter.label,
                    style: tokens.typography.bodySmall.copyWith(
                      color: selected ? c.onPrimary : c.label,
                      fontWeight:
                      selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}