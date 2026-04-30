import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';

class DatePickerRowWidget extends StatelessWidget {
  final DateTime selectedDate;

  const DatePickerRowWidget({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final textDirection = Directionality.of(context);

    final today = DateTime.now();
    final days = List.generate(
      7,
          (index) => DateTime(today.year, today.month, today.day + index),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final gap = tokens.spacing.sm;
        final horizontalPadding = tokens.spacing.md;

        final chipWidth = ((availableWidth - (horizontalPadding * 2) - (gap * 6)) / 7)
            .clamp(54.0, 78.0);

        return SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: horizontalPadding,
            ),
            itemCount: days.length,
            separatorBuilder: (_, __) => SizedBox(width: gap),
            itemBuilder: (context, index) {
              final day = days[index];
              final selected = _isSameDay(day, selectedDate);

              return SizedBox(
                width: chipWidth,
                child: GestureDetector(
                  onTap: () {
                    context.read<SessionsBloc>().add(
                      SessionsDateChanged(day),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? tokens.colors.label
                          : tokens.colors.surface,
                      borderRadius: BorderRadius.circular(tokens.card.radius),
                      border: Border.all(
                        color: selected
                            ? tokens.colors.label
                            : tokens.colors.border.withOpacity(0.35),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayName(context, day.weekday),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: tokens.typography.bodySmall.copyWith(
                            color: selected
                                ? tokens.colors.onPrimary
                                : tokens.colors.body,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day.day.toString(),
                          style: tokens.typography.titleMedium.copyWith(
                            color: selected
                                ? tokens.colors.onPrimary
                                : tokens.colors.label,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dayName(BuildContext context, int weekday) {
    final l10n = AppLocalizations.of(context)!;

    switch (weekday) {
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
        return l10n.daySunday;
      default:
        return '';
    }
  }
}