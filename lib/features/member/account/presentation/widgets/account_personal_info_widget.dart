import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/build4all_profile/domain/entities/member_build4all_profile_entity.dart';

class AccountPersonalInfoWidget extends StatelessWidget {
  final MemberAccountEntity account;
  final MemberBuild4AllProfileEntity profile;

  const AccountPersonalInfoWidget({
    super.key,
    required this.account,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final email = profile.email?.trim();
    final phone = profile.phoneNumber?.trim();

    return Container(
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: tokens.colors.border.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isRtl ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
        children: [
          Text(
            l10n.accountPersonalInfo,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: tokens.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: tokens.spacing.md),

          if (email != null && email.isNotEmpty)
            _InfoRow(
              icon: Icons.email_rounded,
              label: l10n.accountEmail,
              value: email,
            ),

          if (phone != null && phone.isNotEmpty)
            _InfoRow(
              icon: Icons.phone_rounded,
              label: l10n.accountPhone,
              value: phone,
            ),

          if (account.dateOfBirth != null)
            _InfoRow(
              icon: Icons.cake_rounded,
              label: l10n.accountDateOfBirth,
              value: account.dateOfBirth!,
            ),

          if (account.address != null)
            _InfoRow(
              icon: Icons.location_on_rounded,
              label: l10n.accountAddress,
              value: account.address!,
              isLast: true,
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : tokens.spacing.md),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: tokens.colors.primary, size: 18),
          ),
          SizedBox(width: tokens.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.muted,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.label,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}