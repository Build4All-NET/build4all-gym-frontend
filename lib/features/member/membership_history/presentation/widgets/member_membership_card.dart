import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:build4allgym/core/theme/app_theme_tokens.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../domain/entities/member_membership_entity.dart';

/*
 * Displays one complete membership card.
 *
 * The card directly shows all membership information.
 *
 * There is intentionally:
 * - No Renew button
 * - No View Details button
 * - No separate details screen
 */
class MemberMembershipCard extends StatelessWidget {
  final MemberMembershipEntity membership;

  const MemberMembershipCard({
    super.key,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens =
        context.read<ThemeCubit>().state.tokens;

    final AppLocalizations l10n =
    AppLocalizations.of(context)!;

    final String localeName =
    Localizations.localeOf(context).toLanguageTag();

    final Color membershipStatusColor =
    _membershipStatusColor(
      membership.status,
      tokens,
    );

    final Color paymentStatusColor =
    _paymentStatusColor(
      membership.paymentStatus,
      tokens,
    );

    return Container(
      margin: EdgeInsets.only(
        bottom: tokens.spacing.lg,
      ),
      padding: EdgeInsets.all(
        tokens.card.padding,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(
          tokens.card.radius,
        ),
        border: tokens.card.showBorder
            ? Border.all(
          color: tokens.colors.border.withValues(
            alpha: 0.18,
          ),
        )
            : null,
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withValues(
              alpha: 0.07,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MembershipHeader(
            membership: membership,
            statusColor: membershipStatusColor,
            tokens: tokens,
            l10n: l10n,
          ),
          SizedBox(
            height: tokens.spacing.lg,
          ),
          Divider(
            height: 1,
            color: tokens.colors.border.withValues(
              alpha: 0.18,
            ),
          ),
          SizedBox(
            height: tokens.spacing.lg,
          ),

          /*
           * Plan type
           */
          _MembershipInformationRow(
            icon: Icons.category_outlined,
            label: l10n.memberMembershipPlanType,
            value: _planTypeLabel(
              membership.planType,
              l10n,
            ),
            tokens: tokens,
          ),

          /*
           * Payment status
           */
          _MembershipInformationRow(
            icon: Icons.payments_outlined,
            label: l10n.memberMembershipPaymentStatus,
            value: _paymentStatusLabel(
              membership.paymentStatus,
              l10n,
            ),
            valueColor: paymentStatusColor,
            tokens: tokens,
          ),

          /*
           * Start date
           */
          _MembershipInformationRow(
            icon: Icons.calendar_today_outlined,
            label: l10n.memberMembershipStartDate,
            value: _formatDate(
              membership.startDate,
              localeName,
              l10n,
            ),
            tokens: tokens,
          ),

          /*
           * End date
           */
          _MembershipInformationRow(
            icon: Icons.event_outlined,
            label: l10n.memberMembershipEndDate,
            value: _formatDate(
              membership.endDate,
              localeName,
              l10n,
            ),
            tokens: tokens,
          ),

          /*
           * Remaining days
           */
          _MembershipInformationRow(
            icon: Icons.hourglass_bottom_rounded,
            label: l10n.memberMembershipRemainingDays,
            value: membership.remainingDays.toString(),
            tokens: tokens,
          ),

          /*
           * Remaining visits
           */
          _MembershipInformationRow(
            icon: Icons.confirmation_number_outlined,
            label: l10n.memberMembershipRemainingVisits,
            value: membership.remainingVisits?.toString() ??
                l10n.memberMembershipNotAvailable,
            tokens: tokens,
          ),

          /*
           * Plan duration
           */
          _MembershipInformationRow(
            icon: Icons.timelapse_rounded,
            label: l10n.memberMembershipDuration,
            value: membership.durationDays == null
                ? l10n.memberMembershipNotAvailable
                : l10n.memberMembershipDurationDays(
              membership.durationDays!,
            ),
            tokens: tokens,
          ),

          /*
           * Billing cycle
           */
          _MembershipInformationRow(
            icon: Icons.sync_rounded,
            label: l10n.memberMembershipBillingCycle,
            value: _billingCycleLabel(
              membership.billingCycle,
              l10n,
            ),
            tokens: tokens,
          ),

          /*
           * Price
           */
          _MembershipInformationRow(
            icon: Icons.attach_money_rounded,
            label: l10n.memberMembershipPrice,
            value: NumberFormat.currency(
              locale: localeName,
              symbol: '',
              decimalDigits: 2,
            ).format(membership.price),
            tokens: tokens,
          ),

          /*
           * Branch
           */
          _MembershipInformationRow(
            icon: Icons.location_on_outlined,
            label: l10n.memberMembershipBranch,
            value: _nullableText(
              membership.branchName,
              l10n,
            ),
            tokens: tokens,
          ),

          /*
           * Auto renew
           */
          _MembershipInformationRow(
            icon: Icons.autorenew_rounded,
            label: l10n.memberMembershipAutoRenew,
            value: membership.autoRenewEnabled
                ? l10n.memberMembershipEnabled
                : l10n.memberMembershipDisabled,
            valueColor: membership.autoRenewEnabled
                ? tokens.colors.success
                : tokens.colors.muted,
            tokens: tokens,
            showBottomSpacing: false,
          ),
        ],
      ),
    );
  }
}

/*
 * Header containing:
 *
 * - Membership icon
 * - Plan name
 * - Membership status
 */
class _MembershipHeader extends StatelessWidget {
  final MemberMembershipEntity membership;
  final Color statusColor;
  final AppThemeTokens tokens;
  final AppLocalizations l10n;

  const _MembershipHeader({
    required this.membership,
    required this.statusColor,
    required this.tokens,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: tokens.colors.primary.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(
              tokens.card.radius,
            ),
          ),
          child: Icon(
            Icons.workspace_premium_outlined,
            color: tokens.colors.primary,
            size: 26,
          ),
        ),
        SizedBox(
          width: tokens.spacing.md,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _nullableText(
                  membership.planName,
                  l10n,
                ),
                style: tokens.typography.titleMedium.copyWith(
                  color: tokens.colors.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: tokens.spacing.sm,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.md,
                  vertical: tokens.spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(
                    tokens.card.radius,
                  ),
                ),
                child: Text(
                  _membershipStatusLabel(
                    membership.status,
                    l10n,
                  ),
                  style: tokens.typography.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
 * Reusable row used for every membership field.
 */
class _MembershipInformationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final AppThemeTokens tokens;
  final Color? valueColor;
  final bool showBottomSpacing;

  const _MembershipInformationRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.tokens,
    this.valueColor,
    this.showBottomSpacing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: showBottomSpacing
            ? tokens.spacing.md
            : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: tokens.colors.primary,
          ),
          SizedBox(
            width: tokens.spacing.sm,
          ),
          Expanded(
            child: Text(
              label,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: tokens.spacing.md,
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: tokens.typography.bodyMedium.copyWith(
                color: valueColor ??
                    tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * Formats a nullable backend date using the current application locale.
 */
String _formatDate(
    DateTime? date,
    String localeName,
    AppLocalizations l10n,
    ) {
  if (date == null) {
    return l10n.memberMembershipNotAvailable;
  }

  return DateFormat.yMMMd(
    localeName,
  ).format(date);
}

/*
 * Returns the localized not-available value when text is null or empty.
 */
String _nullableText(
    String? value,
    AppLocalizations l10n,
    ) {
  if (value == null || value.trim().isEmpty) {
    return l10n.memberMembershipNotAvailable;
  }

  return value.trim();
}

/*
 * Converts backend membership statuses into localized visible labels.
 */
String _membershipStatusLabel(
    String status,
    AppLocalizations l10n,
    ) {
  switch (status.trim().toUpperCase()) {
    case 'ACTIVE':
      return l10n.memberMembershipStatusActive;

    case 'FROZEN':
      return l10n.memberMembershipStatusFrozen;

    case 'EXPIRED':
      return l10n.memberMembershipStatusExpired;

    case 'CANCELLED':
    case 'CANCELED':
      return l10n.memberMembershipStatusCancelled;

    case 'PENDING':
      return l10n.memberMembershipStatusPending;

    default:
      return status.trim().isEmpty
          ? l10n.memberMembershipNotAvailable
          : status.trim();
  }
}

/*
 * Converts backend payment statuses into localized visible labels.
 */
String _paymentStatusLabel(
    String status,
    AppLocalizations l10n,
    ) {
  switch (status.trim().toUpperCase()) {
    case 'PAID':
      return l10n.memberMembershipPaymentPaid;

    case 'PENDING':
      return l10n.memberMembershipPaymentPending;

    case 'FAILED':
      return l10n.memberMembershipPaymentFailed;

    case 'REFUNDED':
      return l10n.memberMembershipPaymentRefunded;

    case 'UNPAID':
      return l10n.memberMembershipPaymentUnpaid;

    default:
      return status.trim().isEmpty
          ? l10n.memberMembershipNotAvailable
          : status.trim();
  }
}

/*
 * Converts backend plan types into localized visible labels.
 */
String _planTypeLabel(
    String planType,
    AppLocalizations l10n,
    ) {
  switch (planType.trim().toUpperCase()) {
    case 'GYM':
      return l10n.memberMembershipPlanTypeGym;

    case 'CLASSES':
      return l10n.memberMembershipPlanTypeClasses;

    case 'MIXED':
      return l10n.memberMembershipPlanTypeMixed;

    case 'MONTHLY':
      return l10n.memberMembershipPlanTypeMonthly;

    case 'YEARLY':
      return l10n.memberMembershipPlanTypeYearly;

    default:
      return planType.trim().isEmpty
          ? l10n.memberMembershipNotAvailable
          : planType.trim();
  }
}

/*
 * Converts backend billing cycles into localized visible labels.
 */
String _billingCycleLabel(
    String? billingCycle,
    AppLocalizations l10n,
    ) {
  if (billingCycle == null ||
      billingCycle.trim().isEmpty) {
    return l10n.memberMembershipNotAvailable;
  }

  switch (billingCycle.trim().toUpperCase()) {
    case 'DAILY':
      return l10n.memberMembershipBillingDaily;

    case 'WEEKLY':
      return l10n.memberMembershipBillingWeekly;

    case 'MONTHLY':
      return l10n.memberMembershipBillingMonthly;

    case 'YEARLY':
    case 'ANNUAL':
      return l10n.memberMembershipBillingYearly;

    case 'ONE_TIME':
    case 'ONETIME':
      return l10n.memberMembershipBillingOneTime;

    default:
      return billingCycle.trim();
  }
}

/*
 * Returns the theme token color for the membership status.
 */
Color _membershipStatusColor(
    String status,
    AppThemeTokens tokens,
    ) {
  switch (status.trim().toUpperCase()) {
    case 'ACTIVE':
      return tokens.colors.success;

    case 'EXPIRED':
    case 'CANCELLED':
    case 'CANCELED':
      return tokens.colors.danger;

    case 'FROZEN':
    case 'PENDING':
      return tokens.colors.primary;

    default:
      return tokens.colors.muted;
  }
}

/*
 * Returns the theme token color for the payment status.
 */
Color _paymentStatusColor(
    String status,
    AppThemeTokens tokens,
    ) {
  switch (status.trim().toUpperCase()) {
    case 'PAID':
      return tokens.colors.success;

    case 'FAILED':
    case 'UNPAID':
      return tokens.colors.danger;

    case 'PENDING':
    case 'REFUNDED':
      return tokens.colors.primary;

    default:
      return tokens.colors.muted;
  }
}