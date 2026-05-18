import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'membership_status_badge.dart';

/// Main QR card shown under the green header.
///
/// Backend display priority:
/// 1. SESSION
/// 2. MEMBERSHIP
/// 3. NONE
class MemberQrCard extends StatelessWidget {
  final String token;
  final DateTime expiresAt;
  final String membershipStatus;
  final String memberName;
  final String memberCode;

  /// Old compatible fields.
  final String packageName;
  final String validUntil;

  /// New backend display fields.
  final String accessType;
  final String accessTitle;
  final String accessSubtitle;
  final String accessBranchName;
  final DateTime? accessStartTime;
  final DateTime? accessEndTime;

  /// Plan's allowed entry window start "HH:mm" — null if no restriction.
  final String? planGymAccessStart;

  /// Plan's allowed entry window end "HH:mm" — null if no restriction.
  final String? planGymAccessEnd;

  final bool isExpiringSoon;
  final int remainingSeconds;

  const MemberQrCard({
    super.key,
    required this.token,
    required this.expiresAt,
    required this.membershipStatus,
    required this.memberName,
    required this.memberCode,
    required this.packageName,
    required this.validUntil,
    required this.accessType,
    required this.accessTitle,
    required this.accessSubtitle,
    required this.accessBranchName,
    required this.accessStartTime,
    required this.accessEndTime,
    this.planGymAccessStart,
    this.planGymAccessEnd,
    required this.isExpiringSoon,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final shownMemberName = memberName.trim().isEmpty ? '-' : memberName;
    final shownMemberCode = memberCode.trim().isEmpty ? '-' : memberCode;

    final normalizedAccessType = accessType.trim().toUpperCase();

    final shownTitle = accessTitle.trim().isNotEmpty
        ? accessTitle
        : packageName.trim().isNotEmpty
        ? packageName
        : l10n.memberQrPackageFallback;

    final shownSubtitle = accessSubtitle.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.xl),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius + 8),
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
        border: tokens.card.showBorder
            ? Border.all(
          color: tokens.colors.border.withOpacity(0.12),
        )
            : null,
      ),
      child: Column(
        children: [
          MembershipStatusBadge(
            membershipStatus: membershipStatus,
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * QR container.
           *
           * The QR data is the secure UUID token from backend.
           * We do not encode userId or planId.
           */
          Container(
            padding: EdgeInsets.all(tokens.spacing.lg),
            decoration: BoxDecoration(
              color: tokens.colors.background,
              borderRadius: BorderRadius.circular(tokens.card.radius + 8),
            ),
            child: Container(
              padding: EdgeInsets.all(tokens.spacing.lg),
              decoration: BoxDecoration(
                color: tokens.colors.surface,
                borderRadius: BorderRadius.circular(tokens.card.radius),
              ),
              child: QrImageView(
                data: token,
                version: QrVersions.auto,
                size: 210,
                backgroundColor: tokens.colors.surface,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: tokens.colors.label,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: tokens.colors.label,
                ),
              ),
            ),
          ),

          SizedBox(height: tokens.spacing.lg),

          /*
           * Real dynamic member name from backend.
           */
          Text(
            shownMemberName,
            textAlign: TextAlign.center,
            style: tokens.typography.titleMedium.copyWith(
              color: tokens.colors.label,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: tokens.spacing.xs),

          Text(
            '#$shownMemberCode',
            textAlign: TextAlign.center,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.body,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: tokens.spacing.md),

          /*
           * Access chip.
           *
           * If accessType = SESSION:
           * - title is the session/class name
           *
           * If accessType = MEMBERSHIP:
           * - title is the package name
           */
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.md,
              vertical: tokens.spacing.sm,
            ),
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              shownTitle,
              textAlign: TextAlign.center,
              style: tokens.typography.bodySmall.copyWith(
                color: tokens.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (shownSubtitle.isNotEmpty) ...[
            SizedBox(height: tokens.spacing.sm),
            Text(
              shownSubtitle,
              textAlign: TextAlign.center,
              style: tokens.typography.bodySmall.copyWith(
                color: tokens.colors.body,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          SizedBox(height: tokens.spacing.lg),

          if (normalizedAccessType == 'SESSION')
            _SessionInfoBox(
              branchName: accessBranchName,
              startTime: accessStartTime,
              endTime: accessEndTime,
            )
          else
            _MembershipInfoBox(
              validUntil: validUntil,
            ),

          if (isExpiringSoon) ...[
            SizedBox(height: tokens.spacing.md),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacing.md,
                vertical: tokens.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: tokens.colors.error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: tokens.colors.error,
                    size: 18,
                  ),
                  SizedBox(width: tokens.spacing.xs),
                  Text(
                    '${l10n.memberQrExpiresSoon} · $remainingSeconds',
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (planGymAccessStart != null && planGymAccessEnd != null) ...[
            SizedBox(height: tokens.spacing.md),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacing.md,
                vertical: tokens.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: tokens.colors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(tokens.card.radius),
                border: Border.all(
                    color: tokens.colors.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_rounded,
                      color: tokens.colors.primary, size: 16),
                  SizedBox(width: tokens.spacing.xs),
                  Text(
                    'Entry: $planGymAccessStart – $planGymAccessEnd',
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shows membership date info.
class _MembershipInfoBox extends StatelessWidget {
  final String validUntil;

  const _MembershipInfoBox({
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.lg,
        vertical: tokens.spacing.md,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_rounded,
            color: tokens.colors.muted,
            size: 22,
          ),
          SizedBox(width: tokens.spacing.sm),
          Text(
            l10n.memberQrValidUntil,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.body,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            validUntil.trim().isEmpty ? '-' : validUntil,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.label,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows session branch and time.
class _SessionInfoBox extends StatelessWidget {
  final String branchName;
  final DateTime? startTime;
  final DateTime? endTime;

  const _SessionInfoBox({
    required this.branchName,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.lg,
        vertical: tokens.spacing.md,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: tokens.colors.muted,
                size: 22,
              ),
              SizedBox(width: tokens.spacing.sm),
              Expanded(
                child: Text(
                  branchName.trim().isEmpty ? '-' : branchName,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.label,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.sm),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: tokens.colors.muted,
                size: 22,
              ),
              SizedBox(width: tokens.spacing.sm),
              Expanded(
                child: Text(
                  _formatTimeRange(startTime, endTime),
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.label,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return '-';
    }

    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}