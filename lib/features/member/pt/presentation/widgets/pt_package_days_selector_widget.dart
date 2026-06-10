import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../domain/entities/pt_package_entity.dart';
import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_event.dart';

/// Days selector for PT package booking.
///
/// New flow:
/// - No dates.
/// - Days are stable backend codes:
///   MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY.
/// - UI labels come from ARB:
///   l10n.dayMonday, l10n.dayTuesday, ...
///
/// Backend receives later:
/// weeklySchedule: [
///   {
///     "day": "MONDAY",
///     "time": "09:00"
///   }
/// ]
class PtPackageDaysSelectorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklySchedule;
  final PtPackageEntity? selectedPackage;

  // Weekday codes where the trainer has set availability.
  // Days not in this list are shown grayed-out (trainer has no slots configured).
  // Empty list means unknown → treat all days as available.
  final List<String> availableDays;

  const PtPackageDaysSelectorWidget({
    super.key,
    required this.weeklySchedule,
    required this.selectedPackage,
    this.availableDays = const [],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;
    final package = selectedPackage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Rule text.
        ///
        /// Example:
        /// - Choose 1 to 2 days per week
        /// - اختر من 1 إلى 2 أيام في الأسبوع
        ///
        /// Text comes from ARB.
        if (package != null) ...[
          Text(
            package.minDaysPerWeek == package.maxDaysPerWeek
                ? l10n.ptPackageDaysPerWeekExact(package.minDaysPerWeek)
                : l10n.ptPackageDaysPerWeekRange(
              package.minDaysPerWeek,
              package.maxDaysPerWeek,
            ),
            textAlign: TextAlign.start,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: tokens.spacing.md),
        ],

        Wrap(
          spacing: tokens.spacing.sm,
          runSpacing: tokens.spacing.sm,
          children: _weekdays.map((dayCode) {
            final selected = _isSelected(dayCode);
            final trainerAvailable = _isTrainerAvailableOnDay(dayCode);

            return _DayChip(
              label: _weekdayLabel(l10n, dayCode),
              selected: selected,
              trainerAvailable: trainerAvailable,
              onTap: () async {
                final package = selectedPackage;
                if (package == null) return;

                // Day not in trainer's availability → jump straight to request.
                if (!trainerAvailable) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                    helpText: l10n.ptRequestTimePickerHint,
                    builder: (ctx, child) => Directionality(
                      textDirection: Directionality.of(context),
                      child: child!,
                    ),
                  );
                  if (time != null && context.mounted) {
                    context.read<PtPackageBookingBloc>().add(
                      PtPackageTimeRequestSubmitted(
                        day: dayCode,
                        hour: time.hour,
                        minute: time.minute,
                      ),
                    );
                  }
                  return;
                }

                if (!selected &&
                    weeklySchedule.length >= package.maxDaysPerWeek) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.ptPackageMaxDaysReached(package.maxDaysPerWeek),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                context.read<PtPackageBookingBloc>().add(
                  PtPackageDayToggled(day: dayCode),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Stable weekday values used internally and sent to backend.
  ///
  /// Do not translate these.
  static const List<String> _weekdays = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  bool _isSelected(String dayCode) {
    final normalized = dayCode.trim().toUpperCase();
    return weeklySchedule.any(
      (item) => item['day']?.toString().toUpperCase() == normalized,
    );
  }

  // Returns true when trainer has availability on this weekday.
  // Empty availableDays = unknown → assume available.
  bool _isTrainerAvailableOnDay(String dayCode) {
    if (availableDays.isEmpty) return true;
    return availableDays.contains(dayCode.trim().toUpperCase());
  }

  /// Converts stable backend weekday code to localized UI label.
  ///
  /// Backend value:
  /// MONDAY
  ///
  /// UI:
  /// Arabic: الإثنين
  /// English: Mon
  static String _weekdayLabel(AppLocalizations l10n, String dayCode) {
    switch (dayCode) {
      case 'MONDAY':
        return l10n.dayMonday;
      case 'TUESDAY':
        return l10n.dayTuesday;
      case 'WEDNESDAY':
        return l10n.dayWednesday;
      case 'THURSDAY':
        return l10n.dayThursday;
      case 'FRIDAY':
        return l10n.dayFriday;
      case 'SATURDAY':
        return l10n.daySaturday;
      case 'SUNDAY':
        return l10n.daySunday;
      default:
        return dayCode;
    }
  }
}

/// Single selectable weekday chip.
///
/// When [trainerAvailable] is false the chip renders in a muted style to
/// signal that the trainer has no configured slots for this day; tapping it
/// will open a time-picker so the member can send a custom request instead.
class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool trainerAvailable;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.selected,
    required this.trainerAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    final bgColor = selected
        ? tokens.colors.primary
        : trainerAvailable
            ? tokens.colors.surface
            : tokens.colors.border.withOpacity(0.12);

    final borderColor = selected
        ? tokens.colors.primary
        : trainerAvailable
            ? tokens.colors.border.withOpacity(0.35)
            : tokens.colors.border.withOpacity(0.2);

    final textColor = selected
        ? tokens.colors.onPrimary
        : trainerAvailable
            ? tokens.colors.label
            : tokens.colors.muted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 92.0,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.sm,
          vertical: tokens.spacing.md,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tokens.typography.bodySmall.copyWith(
            color: textColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}