import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/member/home/domain/entities/schedule_item.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class TodayScheduleWidget extends StatelessWidget {
  final List<ScheduleItem> items;
  final VoidCallback onViewAll;

  const TodayScheduleWidget({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.memberHomeTodaySchedule,
                style: tokens.typography.headlineSmall.copyWith(
                  color: tokens.colors.label,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onViewAll,
                child: Text(
                  l10n.memberHomeViewAll,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.md),
          if (items.isEmpty)
            const _TodayScheduleEmptyState()
          else
            Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  ScheduleItemCard(item: items[i]),
                  if (i != items.length - 1) SizedBox(height: tokens.spacing.md),
                ],
              ],
            ),
        ],

    );
  }
}

class ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;


  const ScheduleItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    DateTime? startDate;
    bool isPm = false;

    final rawTime = item.startTime.trim();

    if (rawTime.contains('T')) {
      startDate = DateTime.tryParse(rawTime)?.toLocal();
      isPm = startDate != null && startDate.hour >= 12;
    } else {
      final parts = rawTime.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        startDate = DateTime.now().copyWith(hour: hour, minute: minute);
        isPm = hour >= 12;
      }
    }

    final localeCode = Localizations.localeOf(context).languageCode;

    final timeText = startDate == null
        ? '--:--'
        : intl.DateFormat('hh:mm a', localeCode).format(startDate);

    final timeColor = isPm ? tokens.colors.danger : tokens.colors.primary;

    return Container(
      /*
   * Do not use fixed height here.
   * Arabic text and small screens need more vertical space.
   * Fixed height causes the yellow/black overflow warning.
   */
      constraints: const BoxConstraints(minHeight: 106),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacing.lg,
                vertical: tokens.spacing.md,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spacing.md,
                      vertical: tokens.spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: timeColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      timeText,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: timeColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: isRtl ? TextAlign.end : TextAlign.start,
                          style: tokens.typography.titleMedium.copyWith(
                            color: tokens.colors.label,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: tokens.spacing.xs),
                        Text(
                          l10n.memberHomeWithTrainer(item.trainerName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: isRtl ? TextAlign.end : TextAlign.start,
                          style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.body,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: tokens.spacing.sm),
                        Wrap(
                          alignment: isRtl ? WrapAlignment.end : WrapAlignment.start,
                          spacing: tokens.spacing.sm,
                          runSpacing: tokens.spacing.xs,
                          children: [
                            _ScheduleMetaItem(
                              icon: Icons.access_time_rounded,
                              text: l10n.memberHomeDurationMinutes(
                                item.durationMinutes,
                              ),
                            ),
                            if (item.roomName != null &&
                                item.roomName!.trim().isNotEmpty)
                              _ScheduleMetaItem(
                                icon: Icons.location_on_outlined,
                                text: item.roomName!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 5,
            color: tokens.colors.success,
          ),
        ],
      ),
    );
  }
}

class _ScheduleMetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ScheduleMetaItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: tokens.typography.bodySmall.copyWith(
            color: tokens.colors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: tokens.spacing.xs),
        Icon(
          icon,
          size: 15,
          color: tokens.colors.muted,
        ),
      ],
    );
  }
}

class _TodayScheduleEmptyState extends StatelessWidget {
  const _TodayScheduleEmptyState();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.lg,
        vertical: tokens.spacing.xl,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 38,
            color: tokens.colors.primary,
          ),
          SizedBox(height: tokens.spacing.md),
          Text(
            l10n.memberHomeNoScheduleToday,
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}