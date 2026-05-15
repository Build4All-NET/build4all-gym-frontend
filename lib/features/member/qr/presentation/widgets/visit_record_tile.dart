import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/member/qr/domain/entities/visit_record.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

/// One row inside the recent visits list.
///
/// Layout from screenshot:
/// - Right side: date label + time
/// - Left side: duration label + duration value
///
/// No hardcoded UI strings.
/// All text comes from ARB through AppLocalizations.
class VisitRecordTile extends StatelessWidget {
  final VisitRecord visit;
  final bool showDivider;

  const VisitRecordTile({
    super.key,
    required this.visit,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: tokens.spacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*
               * Left column:
               * duration label + duration text
               */
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.memberQrDurationLabel,
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.xs),
                  Text(
                    _formatDuration(context, visit.durationMinutes),
                    style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.label,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /*
               * Right column:
               * relative date + formatted time
               */
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatRelativeDate(context, visit.checkinTime),
                    style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.label,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.xs),
                  Text(
                    _formatTime(context, visit.checkinTime),
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.body,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: tokens.colors.border.withOpacity(0.12),
          ),
      ],
    );
  }

  /// Formats visit duration.
  ///
  /// Rules from task:
  /// - under 60 min = "X دقيقة"
  /// - 60+ min = "X ساعة" or "X.5 ساعة"
  ///
  /// Text is localized through ARB.
  String _formatDuration(BuildContext context, int? durationMinutes) {
    final l10n = AppLocalizations.of(context)!;

    if (durationMinutes == null || durationMinutes <= 0) {
      return '-';
    }

    if (durationMinutes < 60) {
      return l10n.memberQrMinute(durationMinutes);
    }

    final hours = durationMinutes / 60;

    /*
     * If duration is exactly 2 hours, show "2".
     * If duration is 1.5 hours, show "1.5".
     */
    final formattedHours = hours == hours.roundToDouble()
        ? hours.toInt().toString()
        : hours.toStringAsFixed(1);

    return l10n.memberQrHour(formattedHours);
  }

  /// Formats relative date.
  ///
  /// Rules:
  /// - today = localized "Today/اليوم"
  /// - yesterday = localized "Yesterday/أمس"
  /// - otherwise = localized "dd MMMM"
  String _formatRelativeDate(BuildContext context, DateTime value) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final visitDate = DateTime(value.year, value.month, value.day);

    final differenceDays = today.difference(visitDate).inDays;

    if (differenceDays == 0) {
      return l10n.memberQrToday;
    }

    if (differenceDays == 1) {
      return l10n.memberQrYesterday;
    }

    return DateFormat('dd MMMM', locale).format(value);
  }

  /// Formats time using the current app locale.
  ///
  /// Arabic will display Arabic-style AM/PM depending on intl locale support.
  String _formatTime(BuildContext context, DateTime value) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return DateFormat('hh:mm a', locale).format(value);
  }
}