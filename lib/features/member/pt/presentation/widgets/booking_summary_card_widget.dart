import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/trainer_detail_entity.dart';

/// Shows the booking summary after the user selects a time slot.
///
/// This widget is UI only.
/// It does not create the booking.
/// The real booking happens from ConfirmBookingBarWidget.
///
/// No hardcoded Arabic/French text here.
/// All visible labels come from ARB localization files.
class BookingSummaryCardWidget extends StatelessWidget {
  final TrainerDetailEntity trainer;
  final DateTime selectedDate;
  final TimeSlotEntity selectedSlot;

  const BookingSummaryCardWidget({
    super.key,
    required this.trainer,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final textDirection = Directionality.of(context);
    final isRtl = textDirection == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: tokens.colors.success.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: textDirection,
            children: [
              Expanded(
                child: Text(
                  l10n.ptBookingSummary,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.titleMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                width: 28.0,
                height: 28.0,
                decoration: BoxDecoration(
                  color: tokens.colors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: tokens.colors.success,
                  size: 20.0,
                ),
              ),
            ],
          ),

          SizedBox(height: tokens.spacing.md),

          _SummaryRow(
            label: l10n.ptBookingTrainer,
            value: trainer.fullName,
          ),

          SizedBox(height: tokens.spacing.sm),

          _SummaryRow(
            label: l10n.ptBookingDate,
            value: _formatDate(selectedDate),
          ),

          SizedBox(height: tokens.spacing.sm),

          _SummaryRow(
            label: l10n.ptBookingTime,
            value: selectedSlot.label,
          ),

          SizedBox(height: tokens.spacing.md),

          Divider(
            color: tokens.colors.border.withOpacity(0.3),
          ),

          SizedBox(height: tokens.spacing.sm),

          Row(
            textDirection: textDirection,
            children: [
              Expanded(
                child: Text(
                  l10n.ptBookingTotalAmount,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '\$ ${trainer.pricePerSession.toStringAsFixed(0)}',
                textAlign: isRtl ? TextAlign.left : TextAlign.right,
                style: tokens.typography.titleMedium.copyWith(
                  color: tokens.colors.success,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Neutral numeric date format.
  /// No localized month names are hardcoded in Dart.
  static String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final textDirection = Directionality.of(context);
    final isRtl = textDirection == TextDirection.rtl;

    return Row(
      textDirection: textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92.0,
          child: Text(
            label,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: tokens.spacing.sm),
        Expanded(
          child: Text(
            value,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: tokens.typography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}