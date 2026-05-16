import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../bloc/member_qr_bloc.dart';
import '../bloc/member_qr_event.dart';
import '../bloc/member_qr_state.dart';
import '../widgets/member_qr_card.dart';
import '../widgets/recent_visits_list.dart';

/// Main member QR screen.
///
/// This screen is shown inside the QR tab.
/// It listens to MemberQrBloc and renders:
/// - loading
/// - error
/// - loaded QR screen
///
/// No static data.
/// No hardcoded UI text.
/// All UI labels come from ARB via AppLocalizations.
class MemberQrScreen extends StatelessWidget {
  const MemberQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: tokens.colors.background,
        body: BlocBuilder<MemberQrBloc, MemberQrState>(
          builder: (context, state) {
            if (state is MemberQrInitial || state is MemberQrLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: tokens.colors.primary,
                ),
              );
            }

            if (state is MemberQrError) {
              return _MemberQrErrorView(
                message: _mapErrorMessage(context, state.message),
              );
            }

            if (state is MemberQrLoaded) {
              return RefreshIndicator(
                color: tokens.colors.primary,
                onRefresh: () async {
                  context.read<MemberQrBloc>().add(const RefreshMemberQr());
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    /*
                     * Header + QR card in one Stack.
                     *
                     * This is the correct way to make the card overlap
                     * the colored header like the Figma screenshot.
                     */
                    Stack(
                      clipBehavior: Clip.none,

                      children: [
                        _MemberQrHeader(
                          title: l10n.memberQrTitle,
                          subtitle: l10n.memberQrSubtitle,
                        ),

                        /*
                         * The card starts inside the header area.
                         *
                         * Do not change this unless you want to move the card.
                         */
                        Padding(
                          padding: EdgeInsets.only(
                            left: tokens.spacing.lg,
                            right: tokens.spacing.lg,
                            top: 116,
                          ),
                          child: MemberQrCard(
                            token: state.token,
                            expiresAt: state.expiresAt,
                            membershipStatus: state.membershipStatus,
                            memberName: state.memberName,
                            memberCode: state.memberCode,
                            packageName: state.packageName,
                            validUntil: state.validUntil,
                            isExpiringSoon: state.isExpiringSoon,
                            remainingSeconds: state.remainingSeconds,
                          ),
                        ),
                      ],
                    ),

                    /*
                     * Keep this exactly as you had it.
                     */
                    const SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        tokens.spacing.lg,
                        0,
                        tokens.spacing.lg,
                        tokens.spacing.xl,
                      ),
                      child: RecentVisitsList(
                        visits: state.recentVisits,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _mapErrorMessage(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;

    switch (message) {
      case 'member_qr_empty':
        return l10n.memberQrLoadError;
      default:
        return l10n.memberQrLoadError;
    }
  }
}

/// Green top header.
///
/// Design is unchanged.
/// Only text alignment changes depending on language:
/// - English: left
/// - Arabic: right
class _MemberQrHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _MemberQrHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        44,
        tokens.spacing.lg,
        72,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(tokens.card.radius + 16),
          bottomRight: Radius.circular(tokens.card.radius + 16),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              title,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: tokens.typography.headlineSmall.copyWith(
                color: tokens.colors.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          SizedBox(height: tokens.spacing.xs),

          Align(
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              subtitle,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.onPrimary.withOpacity(0.88),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view.
///
/// No hardcoded UI text.
/// Message and button label are localized.
class _MemberQrErrorView extends StatelessWidget {
  final String message;

  const _MemberQrErrorView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              color: tokens.colors.muted,
              size: 56,
            ),
            SizedBox(height: tokens.spacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.body,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: tokens.spacing.lg),
            SizedBox(
              height: tokens.button.height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.button.radius),
                  ),
                ),
                onPressed: () {
                  context.read<MemberQrBloc>().add(const LoadMemberQr());
                },
                child: Text(
                  l10n.memberQrRetry,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}