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

    return Directionality(
      /*
       * Arabic-first screen.
       *
       * The app localization still controls language.
       * This just makes the QR screen layout RTL like the screenshot.
       */
      textDirection: TextDirection.rtl,
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
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _MemberQrHeader(
                        title: l10n.memberQrTitle,
                        subtitle: l10n.memberQrSubtitle,
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        tokens.spacing.lg,
                        0,
                        tokens.spacing.lg,
                        tokens.spacing.xl,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            /*
                             * Negative top margin effect:
                             * card overlaps the green header like screenshot.
                             */
                            Transform.translate(
                              offset: const Offset(0, -36),
                              child:MemberQrCard(
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
                            SizedBox(height: tokens.spacing.lg),
                            RecentVisitsList(
                              visits: state.recentVisits,
                            ),
                          ],
                        ),
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

  /// Maps BLoC/internal error codes to localized UI messages.
  ///
  /// This avoids showing hardcoded repository/BLoC text in the UI.
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

/// Green top header like the screenshots.
///
/// Text comes from ARB.
/// Colors come from theme tokens.
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        56,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.qr_code_2_rounded,
            color: tokens.colors.onPrimary,
            size: 34,
          ),
          SizedBox(height: tokens.spacing.md),
          Text(
            title,
            style: tokens.typography.headlineSmall.copyWith(
              color: tokens.colors.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: tokens.spacing.xs),
          Text(
            subtitle,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.onPrimary.withOpacity(0.88),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view for QR screen.
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