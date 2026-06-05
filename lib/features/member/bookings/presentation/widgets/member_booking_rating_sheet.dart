import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

/*
 * Rating bottom sheet for My Bookings.
 *
 * Shows:
 * - title
 * - booking title
 * - 5 interactive stars
 * - submit button disabled until rating is selected
 *
 * No hardcoded text.
 * All text comes from ARB.
 * All colors/spacings come from theme tokens.
 */
Future<void> showMemberBookingRatingSheet({
  required BuildContext context,
  required String bookingTitle,
  required void Function(int rating) onSubmit,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<ThemeCubit>(),
      child: _MemberBookingRatingSheet(
        bookingTitle: bookingTitle,
        onSubmit: onSubmit,
      ),
    ),
  );
}

class _MemberBookingRatingSheet extends StatefulWidget {
  final String bookingTitle;
  final void Function(int rating) onSubmit;

  const _MemberBookingRatingSheet({
    required this.bookingTitle,
    required this.onSubmit,
  });

  @override
  State<_MemberBookingRatingSheet> createState() =>
      _MemberBookingRatingSheetState();
}

class _MemberBookingRatingSheetState extends State<_MemberBookingRatingSheet> {
  int _selected = 0;
  int _pressed = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.xl,
        tokens.spacing.lg,
        tokens.spacing.xl,
        tokens.spacing.xl + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*
           * Small drag handle.
           */
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: tokens.colors.border.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * Header icon.
           */
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              color: tokens.colors.primary,
              size: 32,
            ),
          ),

          SizedBox(height: tokens.spacing.lg),

          /*
           * Main title.
           */
          Text(
            l10n.memberBookingsRatingTitle,
            textAlign: TextAlign.center,
            style: tokens.typography.titleMedium.copyWith(
              color: tokens.colors.label,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),

          SizedBox(height: tokens.spacing.xs),

          /*
           * Booking title.
           */
          Text(
            widget.bookingTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * Stars row.
           */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final filled = starValue <= _selected;

              return GestureDetector(
                onTapDown: (_) {
                  setState(() => _pressed = starValue);
                },
                onTapCancel: () {
                  setState(() => _pressed = 0);
                },
                onTapUp: (_) {
                  setState(() {
                    _selected = starValue;
                    _pressed = 0;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.all(tokens.spacing.sm),
                  child: AnimatedScale(
                    scale: _pressed == starValue ? 1.25 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Icon(
                      filled
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 40,
                      color: filled
                          ? tokens.colors.primary
                          : tokens.colors.border,
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: tokens.spacing.xs),

          /*
           * Low/high labels.
           */
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spacing.sm),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.memberBookingsRatingLabelLow,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.memberBookingsRatingLabelHigh,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * Submit button.
           */
          SizedBox(
            width: double.infinity,
            height: 52,
            child: AnimatedOpacity(
              opacity: _selected > 0 ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: _selected > 0
                    ? () {
                  Navigator.of(context).pop();
                  widget.onSubmit(_selected);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  disabledBackgroundColor: tokens.colors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.button.radius),
                  ),
                ),
                child: Text(
                  l10n.memberBookingsRateNowButton,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}