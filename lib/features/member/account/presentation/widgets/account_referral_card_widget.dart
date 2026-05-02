import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class AccountReferralCardWidget extends StatelessWidget {
  final String referralCode;

  const AccountReferralCardWidget({super.key, required this.referralCode});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
        isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tokens.colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.card_giftcard_rounded,
                    color: tokens.colors.onPrimary, size: 20),
              ),
              SizedBox(width: tokens.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.accountReferralTitle,
                      style: tokens.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      l10n.accountReferralSubtitle,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.md),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.lg,
              vertical: tokens.spacing.md,
            ),
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(tokens.card.radius),
            ),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.accountReferralCodeLabel,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.muted,
                      ),
                    ),
                    Text(
                      referralCode,
                      style: tokens.typography.titleMedium.copyWith(
                        color: tokens.colors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.accountReferralCopied),
                        backgroundColor: tokens.colors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    color: tokens.colors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.spacing.md),
          SizedBox(
            width: double.infinity,
            height: tokens.button.height,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: tokens.colors.primary,
                foregroundColor: tokens.colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(tokens.button.radius),
                ),
              ),
              icon: const Icon(Icons.share_rounded, size: 18),
              label: Text(
                l10n.accountReferralShare,
                style: TextStyle(
                  fontSize: tokens.button.textSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}