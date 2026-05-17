import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'membership_status_badge.dart';

/// Main QR card shown under the green header.
///
/// Data comes from MemberQrLoaded:
/// - token
/// - membershipStatus
/// - memberName
/// - memberCode
/// - packageName
/// - validUntil
/// - remainingSeconds
///
/// No static member data.
/// No hardcoded UI strings.
/// No hardcoded Colors.*.
class MemberQrCard extends StatelessWidget {
  final String token;
  final DateTime expiresAt;
  final String membershipStatus;
  final String memberName;
  final String memberCode;
  final String packageName;
  final String validUntil;
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
    required this.isExpiringSoon,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final shownPackageName =
    packageName.trim().isEmpty ? l10n.memberQrPackageFallback : packageName;

    final shownMemberName = memberName.trim().isEmpty ? '-' : memberName;

    final shownMemberCode = memberCode.trim().isEmpty ? '-' : memberCode;

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
           *
           * Comes from:
           * GET /api/member/qr -> memberName
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
           * Package chip.
           *
           * Your theme has no warning/gold token.
           * So we use primary with opacity instead of hardcoded gold.
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
              shownPackageName,
              style: tokens.typography.bodySmall.copyWith(
                color: tokens.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(height: tokens.spacing.lg),

          Container(
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
        ],
      ),
    );
  }
}