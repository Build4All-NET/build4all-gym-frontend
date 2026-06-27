// =============================================================================
// FILE: checkin_date_filter_widget.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkin_date_filter_widget.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   Lets the admin pick an arbitrary past date to see who checked in that
//   day. [selectedDate] null means "today". Tapping the chip opens a date
//   picker; a clear (×) button appears once a non-today date is active.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class CheckinDateFilterWidget extends StatelessWidget {
  const CheckinDateFilterWidget({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  final DateTime?                    selectedDate;
  final void Function(DateTime? date) onChanged;

  String _label(AppLocalizations l10n) {
    if (selectedDate == null) return l10n.admin_dashboard_today;
    final d = selectedDate!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now    = DateTime.now();
    final picked = await showDatePicker(
      context:     context,
      initialDate: selectedDate ?? now,
      firstDate:   DateTime(now.year - 2),
      lastDate:    now,
    );
    if (picked != null) onChanged(DateTime(picked.year, picked.month, picked.day));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;
    final isCustom = selectedDate != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color:        isCustom ? c.primary.withOpacity(0.08) : c.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCustom ? c.primary.withOpacity(0.4) : c.border.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 15, color: isCustom ? c.primary : c.muted),
                    const SizedBox(width: 8),
                    Text(
                      _label(l10n),
                      style: TextStyle(
                        fontSize:   13,
                        fontWeight: FontWeight.w600,
                        color:      isCustom ? c.primary : c.label,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isCustom) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onChanged(null),
              child: Tooltip(
                message: l10n.checkins_clearDateFilter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:        c.muted.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.close_rounded, size: 16, color: c.muted),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
