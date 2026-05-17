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
  /// New selected source of truth.
  ///
  /// Example:
  /// [
  ///   {
  ///     "day": "MONDAY",
  ///     "time": "09:00"
  ///   }
  /// ]
  final List<Map<String, dynamic>> weeklySchedule;

  /// Selected package contains:
  /// - minDaysPerWeek
  /// - maxDaysPerWeek
  /// These limits control how many weekdays the user can choose.
  final PtPackageEntity? selectedPackage;

  const PtPackageDaysSelectorWidget({
    super.key,
    required this.weeklySchedule,
    required this.selectedPackage,
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

            return _DayChip(
              label: _weekdayLabel(l10n, dayCode),
              selected: selected,
              onTap: () {
                final package = selectedPackage;

                /// No package selected, no action.
                if (package == null) return;

                /// Frontend guard:
                /// do not allow selecting more than maxDaysPerWeek.
                ///
                /// Backend also validates this.
                if (!selected &&
                    weeklySchedule.length >= package.maxDaysPerWeek) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.ptPackageMaxDaysReached(
                          package.maxDaysPerWeek,
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                /// Toggle this stable weekday in Bloc.
                ///
                /// Important:
                /// - Send stable backend code.
                /// - Do not send translated label.
                /// - Do not send date.
                context.read<PtPackageBookingBloc>().add(
                  PtPackageDayToggled(
                    day: dayCode,
                  ),
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

  /// Checks if a backend day code is already selected.
  bool _isSelected(String dayCode) {
    final normalized = dayCode.trim().toUpperCase();

    return weeklySchedule.any(
          (item) => item['day']?.toString().toUpperCase() == normalized,
    );
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
class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

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
          color: selected ? tokens.colors.primary : tokens.colors.surface,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: selected
                ? tokens.colors.primary
                : tokens.colors.border.withOpacity(0.35),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tokens.typography.bodySmall.copyWith(
            color: selected ? tokens.colors.onPrimary : tokens.colors.label,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}