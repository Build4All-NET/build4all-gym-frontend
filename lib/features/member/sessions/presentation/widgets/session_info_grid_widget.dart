import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/session_detail_entity.dart';

class SessionInfoGridWidget extends StatelessWidget {
  final SessionDetailEntity session;

  const SessionInfoGridWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final startDate = session.startTime;
    final endTime = session.endTime;

    final dateStr = _formatDate(context, startDate);
    final startTimeStr =
        '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
    final endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    final timeStr = isRtl
        ? '$endTimeStr - $startTimeStr'
        : '$startTimeStr - $endTimeStr';

    final items = [
      _GridItem(
        icon: Icons.access_time_rounded,
        label: l10n.sessionDetailTimeLabel,
        value: timeStr,
      ),
      _GridItem(
        icon: Icons.calendar_today_rounded,
        label: l10n.sessionDetailDateLabel,
        value: dateStr,
      ),
      _GridItem(
        icon: Icons.people_alt_rounded,
        label: l10n.sessionDetailSeatsLabel,
        value: l10n.sessionDetailSeatsRemaining(session.availableSeats),
      ),
      _GridItem(
        icon: Icons.location_on_rounded,
        label: l10n.sessionDetailLocationLabel,
        value: session.roomName,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: tokens.spacing.sm,
        mainAxisSpacing: tokens.spacing.sm,
        childAspectRatio: 2.4,
        children: items.map((item) => _GridCell(item: item)).toList(),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final dayName = _dayName(context, date.weekday);
    final monthName = _monthName(context, date.month);

    if (isRtl) {
      return '$dayName، ${date.day} $monthName ${date.year}';
    } else {
      return '$dayName, $monthName ${date.day}, ${date.year}';
    }
  }

  String _dayName(BuildContext context, int weekday) {
    final l10n = AppLocalizations.of(context)!;
    switch (weekday) {
      case DateTime.monday: return l10n.dayMonday;
      case DateTime.tuesday: return l10n.dayTuesday;
      case DateTime.wednesday: return l10n.dayWednesday;
      case DateTime.thursday: return l10n.dayThursday;
      case DateTime.friday: return l10n.dayFriday;
      case DateTime.saturday: return l10n.daySaturday;
      case DateTime.sunday: return l10n.daySunday;
      default: return '';
    }
  }

  String _monthName(BuildContext context, int month) {
    final l10n = AppLocalizations.of(context)!;
    switch (month) {
      case 1: return l10n.monthJanuary;
      case 2: return l10n.monthFebruary;
      case 3: return l10n.monthMarch;
      case 4: return l10n.monthApril;
      case 5: return l10n.monthMay;
      case 6: return l10n.monthJune;
      case 7: return l10n.monthJuly;
      case 8: return l10n.monthAugust;
      case 9: return l10n.monthSeptember;
      case 10: return l10n.monthOctober;
      case 11: return l10n.monthNovember;
      case 12: return l10n.monthDecember;
      default: return '';
    }
  }
}

class _GridItem {
  final IconData icon;
  final String label;
  final String value;
  const _GridItem({required this.icon, required this.label, required this.value});
}

class _GridCell extends StatelessWidget {
  final _GridItem item;
  const _GridCell({required this.item});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: tokens.colors.border.withOpacity(0.15)),
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: tokens.colors.primary, size: 15),
          ),
          SizedBox(width: tokens.spacing.xs),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.muted,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.label,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}