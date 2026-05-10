import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../domain/entities/time_slot_entity.dart';
import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_event.dart';
import '../bloc/pt_package_booking_state.dart';

/// Time selector for PT package booking.
///
/// New real availability flow:
/// - User selects stable weekdays first.
/// - Bloc loads backend weekly slots for each selected weekday:
///   GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
/// - This widget displays only those backend slots.
///
/// No hardcoded time list here.
class PtPackageTimeSelectorWidget extends StatelessWidget {
  final PtPackageBookingLoaded state;

  const PtPackageTimeSelectorWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    if (state.weeklySchedule.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: state.weeklySchedule.map((item) {
        final dayCode = item['day']?.toString().trim().toUpperCase() ?? '';
        final selectedTime = item['time']?.toString().trim();

        final isLoading = state.isLoadingSlotsForDay(dayCode);
        final error = state.slotErrorForDay(dayCode);
        final slots = state.availableSlotsForDay(dayCode);

        return Padding(
          padding: EdgeInsets.only(bottom: tokens.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Localized weekday label.
              Text(
                _weekdayLabel(l10n, dayCode),
                textAlign: TextAlign.start,
                style: tokens.typography.bodySmall.copyWith(
                  color: tokens.colors.label,
                  fontWeight: FontWeight.w900,
                ),
              ),

              SizedBox(height: tokens.spacing.sm),

              if (isLoading)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: tokens.colors.primary,
                    ),
                  ),
                )
              else if (error != null)
                Text(
                  _resolveSlotError(l10n, error),
                  textAlign: TextAlign.start,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                )
              else if (slots.isEmpty)
                  Text(
                    l10n.ptPackageNoAvailableSlots,
                    textAlign: TextAlign.start,
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  Wrap(
                    spacing: tokens.spacing.sm,
                    runSpacing: tokens.spacing.sm,
                    children: slots.map((slot) {
                      final time = _formatSlotTime(slot);
                      final selected = selectedTime == time;

                      return _TimeChip(
                        time: time,
                        selected: selected,
                        onTap: () {
                          context.read<PtPackageBookingBloc>().add(
                            PtPackageTimeSelected(
                              day: dayCode,
                              time: time,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Extracts HH:mm from backend slot startTime.
  ///
  /// Backend may return:
  /// "2026-05-09T09:00:00"
  ///
  /// We only need:
  /// "09:00"
  static String _formatSlotTime(TimeSlotEntity slot) {
    final rawStartTime = slot.startTime.toString();

    try {
      final parsed = DateTime.parse(rawStartTime);

      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');

      return '$hour:$minute';
    } catch (_) {
      /// Fallback if startTime is already "09:00"
      if (rawStartTime.length >= 5) {
        return rawStartTime.substring(0, 5);
      }

      return rawStartTime;
    }
  }

  /// Converts backend weekday code to localized UI label.
  static String _weekdayLabel(AppLocalizations l10n, String dayCode) {
    switch (dayCode.trim().toUpperCase()) {
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

  /// Converts internal error keys to ARB text.
  static String _resolveSlotError(
      AppLocalizations l10n,
      String error,
      ) {
    switch (error) {
      case 'ptWeeklySlotsFailed':
        return l10n.ptWeeklySlotsFailed;
      default:
        return error;
    }
  }
}

/// Single selectable time chip.
///
/// Time values are backend/internal values like "09:00".
/// They are not translated.
class _TimeChip extends StatelessWidget {
  final String time;
  final bool selected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.time,
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
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.lg,
          vertical: tokens.spacing.sm,
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
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            time,
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(
              color: selected ? tokens.colors.onPrimary : tokens.colors.label,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}