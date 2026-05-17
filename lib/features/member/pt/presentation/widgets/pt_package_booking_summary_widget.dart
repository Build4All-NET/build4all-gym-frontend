import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../bloc/pt_package_booking_state.dart';

/// Summary card for package booking.
///
/// New flow:
/// - selected package
/// - selected weekly schedule
/// - final price
///
/// weeklySchedule example:
/// [
///   {
///     "day": "MONDAY",
///     "time": "09:00"
///   }
/// ]
///
/// Important:
/// - No dates.
/// - UI weekday labels come from ARB.
/// - Backend receives stable weekday codes.
class PtPackageBookingSummaryWidget extends StatelessWidget {
  final PtPackageBookingLoaded state;

  const PtPackageBookingSummaryWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;

    final package = state.selectedPackage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(
          color: tokens.colors.border.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Selected package row.
          _SummaryRow(
            label: l10n.ptPackageSelectedPackage,
            value: package?.name ?? '-',
          ),

          SizedBox(height: tokens.spacing.sm),

          /// Selected days row.
          ///
          /// Uses existing ARB key:
          /// ptPackageSelectedDays
          _SummaryRow(
            label: l10n.ptPackageSelectedDays,
            value: state.weeklySchedule.isEmpty
                ? '-'
                : state.weeklySchedule
                .map((item) {
              final dayCode = item['day']?.toString() ?? '';
              return _weekdayLabel(l10n, dayCode);
            })
                .where((value) => value.trim().isNotEmpty)
                .join('، '),
          ),

          SizedBox(height: tokens.spacing.sm),

          /// Selected time row.
          ///
          /// Uses existing ARB key:
          /// ptPackageSelectedTime
          ///
          /// Since every selected day has its own time,
          /// we show day + time together.
          _SummaryRow(
            label: l10n.ptPackageSelectedTime,
            value: state.weeklySchedule.isEmpty
                ? '-'
                : state.weeklySchedule
                .map((item) {
              final dayCode = item['day']?.toString() ?? '';
              final time = item['time']?.toString() ?? '';

              final dayLabel = _weekdayLabel(l10n, dayCode);

              if (time.trim().isEmpty) {
                return '$dayLabel: -';
              }

              return '$dayLabel: $time';
            })
                .where((value) => value.trim().isNotEmpty)
                .join('، '),
          ),

          SizedBox(height: tokens.spacing.sm),

          /// Final price row.
          ///
          /// Price comes from backend package.finalPrice.
          _SummaryRow(
            label: l10n.ptPackageFinalPrice,
            value: package == null
                ? '-'
                : '\$${package.finalPrice.toStringAsFixed(2)}',
            emphasize: true,
          ),
        ],
      ),
    );
  }

  /// Converts backend weekday code to localized UI label.
  ///
  /// Backend:
  /// MONDAY
  ///
  /// UI:
  /// Arabic / English from ARB.
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
}

/// One row inside the summary card.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.bodyMedium.copyWith(
              color: emphasize ? tokens.colors.primary : tokens.colors.label,
              fontWeight: emphasize ? FontWeight.w900 : FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}