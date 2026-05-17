import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/time_slot_entity.dart';

class BookingDateTimeSelectorWidget extends StatelessWidget {
  final DateTime selectedDate;
  final TimeSlotEntity? selectedSlot;
  final List<TimeSlotEntity> slots;
  final bool isSlotsLoading;
  final String? slotsError;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeSlotEntity> onSlotChanged;

  const BookingDateTimeSelectorWidget({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.slots,
    required this.isSlotsLoading,
    required this.slotsError,
    required this.onDateChanged,
    required this.onSlotChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            title: l10n.ptBookingChooseDate,
          ),

          SizedBox(height: tokens.spacing.md),

          _DateSelector(
            selectedDate: selectedDate,
            onChanged: onDateChanged,
          ),

          SizedBox(height: tokens.spacing.xl),

          _SectionTitle(
            title: l10n.ptBookingChooseTime,
          ),

          SizedBox(height: tokens.spacing.md),

          if (isSlotsLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(tokens.spacing.md),
                child: CircularProgressIndicator(
                  color: tokens.colors.primary,
                ),
              ),
            )
          else if (slotsError != null)
            _MessageBox(
              message: slotsError!,
              icon: Icons.error_outline_rounded,
            )
          else if (slots.isEmpty)
              _MessageBox(
                message: l10n.ptBookingNoSlotsForDate,
                icon: Icons.event_busy_rounded,
              )
            else
              _TimeSlots(
                slots: slots,
                selectedSlot: selectedSlot,
                onChanged: onSlotChanged,
              ),
        ],
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          title,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          style: tokens.typography.bodyMedium.copyWith(
            color: tokens.colors.label,
            fontWeight: FontWeight.w900,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

// ── Date selector ─────────────────────────────────────────────────────────────

class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const _DateSelector({
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final today = DateTime.now();

    final dates = List.generate(
      7,
          (index) => DateTime(today.year, today.month, today.day + index),
    );

    return SizedBox(
      height: 76.0,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: isRtl,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => onChanged(date),
            child: Container(
              width: 62.0,
              margin: EdgeInsetsDirectional.only(
                end: tokens.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? tokens.colors.primary
                    : tokens.colors.surface,
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(
                  color: isSelected
                      ? tokens.colors.primary
                      : tokens.colors.border.withOpacity(0.15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayLabel(l10n, date),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.typography.bodySmall.copyWith(
                      color: isSelected
                          ? tokens.colors.onPrimary
                          : tokens.colors.muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.0,
                    ),
                  ),

                  SizedBox(height: tokens.spacing.xs),

                  Text(
                    date.day.toString(),
                    style: tokens.typography.bodyMedium.copyWith(
                      color: isSelected
                          ? tokens.colors.onPrimary
                          : tokens.colors.label,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0,
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

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String _weekdayLabel(AppLocalizations l10n, DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return l10n.dayMonday;
      case DateTime.tuesday:
        return l10n.dayTuesday;
      case DateTime.wednesday:
        return l10n.dayWednesday;
      case DateTime.thursday:
        return l10n.dayThursday;
      case DateTime.friday:
        return l10n.dayFriday;
      case DateTime.saturday:
        return l10n.daySaturday;
      case DateTime.sunday:
      default:
        return l10n.daySunday;
    }
  }
}

// ── Time slots ────────────────────────────────────────────────────────────────

class _TimeSlots extends StatelessWidget {
  final List<TimeSlotEntity> slots;
  final TimeSlotEntity? selectedSlot;
  final ValueChanged<TimeSlotEntity> onChanged;

  const _TimeSlots({
    required this.slots,
    required this.selectedSlot,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: Wrap(
          alignment: isRtl ? WrapAlignment.end : WrapAlignment.start,
          spacing: tokens.spacing.sm,
          runSpacing: tokens.spacing.sm,
          children: slots.map((slot) {
            final isSelected = selectedSlot?.id != null && slot.id != null
                ? selectedSlot!.id == slot.id
                : selectedSlot?.startTime == slot.startTime;

            return GestureDetector(
              onTap: slot.available ? () => onChanged(slot) : null,
              child: Opacity(
                opacity: slot.available ? 1.0 : 0.45,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tokens.spacing.lg,
                    vertical: tokens.spacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tokens.colors.primary
                        : tokens.colors.surface,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isSelected
                          ? tokens.colors.primary
                          : tokens.colors.border.withOpacity(0.15),
                    ),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      slot.label,
                      textAlign: TextAlign.center,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: isSelected
                            ? tokens.colors.onPrimary
                            : tokens.colors.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Message box ───────────────────────────────────────────────────────────────

class _MessageBox extends StatelessWidget {
  final String message;
  final IconData icon;

  const _MessageBox({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.md),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: tokens.colors.border.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: tokens.colors.muted,
            size: 28.0,
          ),

          SizedBox(height: tokens.spacing.sm),

          Text(
            message,
            textAlign: TextAlign.center,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}