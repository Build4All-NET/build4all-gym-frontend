import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/member_booking_entity.dart';
import 'member_booking_status_chip.dart';

/*
 * Card used by My Bookings screen.
 *
 * It supports both:
 * - CLASS booking
 * - PT session
 *
 * Backend decides:
 * - status
 * - canRequestCancel
 * - cancelRequestPending
 * - canReview
 *
 * UI only displays those flags.
 */
class MemberBookingCard extends StatelessWidget {
  final MemberBookingEntity booking;
  final bool actionLoading;
  final VoidCallback onCancelTap;
  final VoidCallback onReviewTap;

  const MemberBookingCard({
    super.key,
    required this.booking,
    required this.actionLoading,
    required this.onCancelTap,
    required this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final title = _title(l10n);
    final statusLabel = _localizedStatus(l10n);

    /*
     * Stack is used to overlay the green accent bar on the end side.
     * The bar sits inside the card margin so it clips nicely.
     */
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: tokens.spacing.lg,
            vertical: tokens.spacing.sm,
          ),
          padding: EdgeInsets.all(tokens.card.padding),
          decoration: BoxDecoration(
            color: tokens.colors.surface,
            borderRadius: BorderRadius.circular(tokens.card.radius),
            boxShadow: tokens.card.showShadow
                ? [
              BoxShadow(
                color: tokens.colors.primary.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: isRtl
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              /*
               * Top row: title + status chip (icon removed).
               */
              Row(
                textDirection:
                isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign:
                      isRtl ? TextAlign.right : TextAlign.left,
                      style: tokens.typography.titleMedium.copyWith(
                        color: tokens.colors.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.sm),
                  MemberBookingStatusChip(
                    label: statusLabel,
                    status: booking.status,
                  ),
                ],
              ),
              SizedBox(height: tokens.spacing.sm),
              _InfoLine(
                icon: Icons.person_rounded,
                text: booking.trainerName ?? '',
              ),

              SizedBox(height: tokens.spacing.sm),

              /*
               * Date + time on one row.
               */
              Row(
                textDirection:
                isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 15,
                    color: tokens.colors.muted,
                  ),
                  SizedBox(width: tokens.spacing.xs),
                  Text(
                    _dateText(context),
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: tokens.spacing.md),
                  Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: tokens.colors.muted,
                  ),
                  SizedBox(width: tokens.spacing.xs),
                  Expanded(
                    child: Text(
                      _timeText(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign:
                      isRtl ? TextAlign.right : TextAlign.left,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.body,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: tokens.spacing.xs),

              /*
               * Duration + room on one row.
               */
              Row(
                textDirection:
                isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Icon(
                    Icons.timer_rounded,
                    size: 15,
                    color: tokens.colors.muted,
                  ),
                  SizedBox(width: tokens.spacing.xs),
                  Text(
                    '${booking.durationMinutes}',
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((booking.roomName ?? '').trim().isNotEmpty) ...[
                    SizedBox(width: tokens.spacing.md),
                    Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: tokens.colors.muted,
                    ),
                    SizedBox(width: tokens.spacing.xs),
                    Expanded(
                      child: Text(
                        booking.roomName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: isRtl
                            ? TextAlign.right
                            : TextAlign.left,
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.body,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              /*
               * Branch name row — only if present.
               */
              if ((booking.branchName ?? '').trim().isNotEmpty) ...[
                SizedBox(height: tokens.spacing.xs),
                _InfoLine(
                  icon: Icons.business_rounded,
                  text: booking.branchName!,
                ),
              ],

              /*
               * PT package progress: Session X of Y.
               */
              if (booking.isPt &&
                  booking.sessionIndex != null &&
                  booking.totalSessions != null) ...[
                SizedBox(height: tokens.spacing.sm),
                Row(
                  textDirection: isRtl
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 16,
                      color: tokens.colors.primary,
                    ),
                    SizedBox(width: tokens.spacing.xs),
                    Expanded(
                      child: Text(
                        l10n.memberBookingsSessionProgress(
                          booking.sessionIndex!,
                          booking.totalSessions!,
                        ),
                        textAlign: isRtl
                            ? TextAlign.right
                            : TextAlign.left,
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (booking.canRequestCancel ||
                  booking.cancelRequestPending ||
                  booking.canReview) ...[
                SizedBox(height: tokens.spacing.md),
                _ActionArea(
                  booking: booking,
                  actionLoading: actionLoading,
                  onCancelTap: onCancelTap,
                  onReviewTap: onReviewTap,
                ),
              ],
            ],
          ),
        ),

        /*
         * Green accent bar on the end side of the card.
         * Sits inside the card margin so it clips flush with the card edge.
         */
        PositionedDirectional(
          top: tokens.spacing.sm + 16,
          bottom: tokens.spacing.sm + 16,
          end: tokens.spacing.lg,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: tokens.colors.success,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  String _title(AppLocalizations l10n) {
    final raw = booking.title?.trim();

    if (raw != null && raw.isNotEmpty) {
      return raw;
    }

    return booking.isPt
        ? l10n.memberBookingsPtDefaultTitle
        : l10n.memberBookingsClassDefaultTitle;
  }

  String _localizedStatus(AppLocalizations l10n) {
    switch (booking.displayStatusKey) {
      case 'bookingStatusConfirmed':
        return l10n.bookingStatusConfirmed;
      case 'bookingStatusWaitlisted':
        return l10n.bookingStatusWaitlisted;
      case 'bookingStatusPending':
        return l10n.bookingStatusPending;
      case 'bookingStatusCancelRequested':
        return l10n.bookingStatusCancelRequested;
      case 'bookingStatusCancelled':
        return l10n.bookingStatusCancelled;
      case 'bookingStatusCompleted':
        return l10n.bookingStatusCompleted;
      default:
        return l10n.bookingStatusUnknown;
    }
  }

  String _dateText(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    return material.formatMediumDate(booking.startTime);
  }

  String _timeText(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    final start = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(booking.startTime),
    );
    final end = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(booking.endTime),
    );
    return '$start - $end';
  }
}

class _IconBox extends StatelessWidget {
  final bool isPt;

  const _IconBox({required this.isPt});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: tokens.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Icon(
        isPt
            ? Icons.fitness_center_rounded
            : Icons.sports_gymnastics_rounded,
        color: tokens.colors.primary,
        size: 26,
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(
          icon,
          size: 15,
          color: tokens.colors.muted,
        ),
        SizedBox(width: tokens.spacing.xs),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.body,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionArea extends StatelessWidget {
  final MemberBookingEntity booking;
  final bool actionLoading;
  final VoidCallback onCancelTap;
  final VoidCallback onReviewTap;

  const _ActionArea({
    required this.booking,
    required this.actionLoading,
    required this.onCancelTap,
    required this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    /*
     * Cancel pending — static label, no button interaction.
     */
    if (booking.cancelRequestPending) {
      return Container(
        width: double.infinity,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tokens.colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(tokens.button.radius),
          border: Border.all(
            color: tokens.colors.primary.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_top_rounded,
              size: 16,
              color: tokens.colors.primary,
            ),
            SizedBox(width: 6),
            Text(
              l10n.memberBookingsCancelPending,
              style: tokens.typography.bodySmall.copyWith(
                color: tokens.colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
    }

    /*
     * Review button — solid green, full width, star icon.
     */
    if (booking.canReview) {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton.icon(
          onPressed: onReviewTap,
          icon: Icon(
            Icons.star_border_rounded,
            color: tokens.colors.onPrimary,
            size: 18,
          ),
          label: Text(
            l10n.memberBookingsReviewButton,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.onPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: tokens.colors.primary,
            foregroundColor: tokens.colors.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(tokens.button.radius),
            ),
          ),
        ),
      );
    }

    /*
     * Cancel button — outlined red, cancel icon.
     */
    if (booking.canRequestCancel) {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton.icon(
          onPressed: actionLoading ? null : onCancelTap,
          icon: actionLoading
              ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: tokens.colors.danger,
            ),
          )
              : Icon(
            Icons.cancel_outlined,
            color: tokens.colors.danger,
            size: 18,
          ),
          label: Text(
            l10n.memberBookingsCancelButton,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.danger,
              fontWeight: FontWeight.w900,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: tokens.colors.danger),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(tokens.button.radius),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}