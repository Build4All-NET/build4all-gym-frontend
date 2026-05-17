import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/member/qr/domain/entities/visit_record.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

/// One visit row inside a card.
///
/// Figma Arabic layout:
///
///   RIGHT side              LEFT side
///   ─────────────────       ──────────────
///   اليوم  (bold)           المدة  (muted small)
///   ص 08:30 (muted)         2 ساعة (bold)
///
/// showDivider kept for API compatibility.
/// No hardcoded colors. No hardcoded strings.
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── RIGHT side (Arabic): date + time ─────────────────────────
              // ── LEFT side (English): duration ────────────────────────────
              if (isArabic) ...[
                // Arabic RIGHT = date/time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatRelativeDate(context, visit.checkinTime),
                      textAlign: TextAlign.end,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.label,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: tokens.spacing.xs),
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Text(
                        _formatTime(context, visit.checkinTime),
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.body,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Arabic LEFT = duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.memberQrDurationLabel,
                      textAlign: TextAlign.start,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: tokens.spacing.xs),
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Text(
                        _formatDuration(context, visit.durationMinutes),
                        style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.label,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // English LEFT = duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.memberQrDurationLabel,
                      textAlign: TextAlign.start,
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

                // English RIGHT = date/time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatRelativeDate(context, visit.checkinTime),
                      textAlign: TextAlign.end,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.label,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: tokens.spacing.xs),
                    Text(
                      _formatTime(context, visit.checkinTime),
                      textAlign: TextAlign.end,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.body,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
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

  String _formatDuration(BuildContext context, int? durationMinutes) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    if (durationMinutes == null || durationMinutes <= 0) return '-';

    if (durationMinutes < 60) {
      if (languageCode == 'en') return '$durationMinutes min';
      return l10n.memberQrMinute(durationMinutes);
    }

    final hours = durationMinutes / 60;
    final formattedHours = hours == hours.roundToDouble()
        ? hours.toInt().toString()
        : hours.toStringAsFixed(1);

    if (languageCode == 'en') return '$formattedHours h';
    return l10n.memberQrHour(formattedHours);
  }

  String _formatRelativeDate(BuildContext context, DateTime value) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final visitDate = DateTime(value.year, value.month, value.day);
    final differenceDays = today.difference(visitDate).inDays;

    if (differenceDays == 0) return l10n.memberQrToday;
    if (differenceDays == 1) return l10n.memberQrYesterday;
    return DateFormat('dd MMMM', locale).format(value);
  }

  String _formatTime(BuildContext context, DateTime value) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'en') return DateFormat('hh:mm a', 'en').format(value);
    return DateFormat('hh:mm a', 'ar').format(value);
  }
}