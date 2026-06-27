import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/core/network/globals.dart' as g;
import 'package:build4allgym/features/member/bookings/domain/usecases/submit_member_booking_review_usecase.dart';
import 'package:build4allgym/features/member/bookings/data/repositories/member_bookings_repository_impl.dart';
import 'package:build4allgym/features/member/bookings/data/services/member_bookings_service.dart';
import 'package:build4allgym/features/member/bookings/domain/usecases/get_member_bookings_usecase.dart';
import 'package:build4allgym/features/member/bookings/domain/usecases/request_member_booking_cancel_usecase.dart';
import 'package:build4allgym/features/member/bookings/presentation/screen/member_bookings_screen.dart';

class AccountActionCardsWidget extends StatelessWidget {
  final MemberAccountEntity account;

  const AccountActionCardsWidget({
    super.key,
    required this.account,
  });

  void _openBookings(BuildContext context) {
    final service = MemberBookingsService(g.dio());
    final repository = MemberBookingsRepositoryImpl(service);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MemberBookingsScreen(
          getMemberBookingsUseCase: GetMemberBookingsUseCase(repository),
          requestCancelUseCase: RequestMemberBookingCancelUseCase(repository),
          submitReviewUseCase: SubmitMemberBookingReviewUseCase(repository),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(tokens.card.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.card.radius),
        onTap: () => _openBookings(context),
        child: Ink(
          width: double.infinity,
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
            isRtl ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment:
                isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Icon(
                  Icons.bookmark_rounded,
                  color: tokens.colors.onPrimary,
                  size: 28,
                ),
              ),
              Text(
                '${account.activeBookingsCount}',
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: tokens.typography.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.accountMyBookings,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: tokens.typography.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}