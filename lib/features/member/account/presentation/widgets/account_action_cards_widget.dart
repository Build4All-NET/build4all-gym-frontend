import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';

class AccountActionCardsWidget extends StatelessWidget {
  final MemberAccountEntity account;

  const AccountActionCardsWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        // Bookings card
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to sessions screen
            },
            child: Container(
              height: 110,
              padding: EdgeInsets.all(tokens.spacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    tokens.colors.danger,
                    tokens.colors.success,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(tokens.card.radius),
              ),
              child: Column(
                crossAxisAlignment:
                isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Icon(Icons.bookmark_rounded,
                      color: tokens.colors.onPrimary, size: 28),
                  Text(
                    '${account.activeBookingsCount}',
                    style: tokens.typography.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    l10n.accountMyBookings,
                    textAlign: isRtl ? TextAlign.end : TextAlign.start,
                    style: tokens.typography.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: tokens.spacing.md),
        // Loyalty points card
        Expanded(
          child: Container(
            height: 110,
            padding: EdgeInsets.all(tokens.spacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tokens.colors.primary,
                  tokens.colors.primary.withOpacity(0.72),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(tokens.card.radius),
            ),
            child: Column(
              crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Icon(Icons.card_giftcard_rounded,
                    color: tokens.colors.onPrimary, size: 28),
                Text(
                  '450',
                  style: tokens.typography.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  l10n.accountLoyaltyPoints,
                  textAlign: isRtl ? TextAlign.end : TextAlign.start,
                  style: tokens.typography.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}