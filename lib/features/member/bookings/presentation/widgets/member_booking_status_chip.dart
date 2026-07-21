import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';

/*
 * Status chip shown on booking cards.
 *
 * It receives already-localized text from the screen/card.
 * The backend only sends displayStatusKey.
 * The UI translates it before passing it here.
 *
 * Color mapping (Figma):
 * - confirmed / booked / checked-in  → success (green)
 * - completed / attended             → muted (gray)  ← Figma shows gray pill
 * - cancelled / no-show              → danger (red)
 * - pending / waitlisted / requested → primary (brand color)
 * - unknown / default                → muted (gray)
 */
class MemberBookingStatusChip extends StatelessWidget {
  final String label;
  final String status;

  const MemberBookingStatusChip({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final color = _statusColor(tokens, status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withOpacity(0.24),
        ),
      ),
      child: Text(
        label,
        style: tokens.typography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _statusColor(dynamic tokens, String status) {
    switch (status) {
      case 'BOOKED':
      case 'SCHEDULED':
      case 'CHECKED_IN':
        return tokens.colors.success;

    /*
       * Completed sessions use muted/gray — matches Figma pill style.
       */
      case 'COMPLETED':
      case 'ATTENDED':
        return tokens.colors.muted;

      case 'CANCELLED':
      case 'NO_SHOW':
      case 'DECLINED':
        return tokens.colors.danger;

      case 'WAITLISTED':
      case 'PENDING':
      case 'REQUESTED':
      case 'CANCEL_REQUESTED':
      case 'PAYMENT_PENDING':
        return tokens.colors.primary;

      default:
        return tokens.colors.muted;
    }
  }
}