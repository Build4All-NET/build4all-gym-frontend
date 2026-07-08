import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/member_membership_bloc.dart';
import '../bloc/member_membership_event.dart';
import '../bloc/member_membership_state.dart';
import '../widgets/member_membership_card.dart';

/*
 * Displays all memberships that belong to the logged-in member.
 *
 * The screen supports:
 * - Initial loading
 * - Empty state
 * - Error state
 * - Retry
 * - Pull-to-refresh
 *
 * The screen does not contain:
 * - Renew button
 * - View Details button
 * - Membership details navigation
 *
 * Each membership displays all its information directly inside its card.
 */
class MemberMembershipHistoryScreen extends StatefulWidget {
  const MemberMembershipHistoryScreen({
    super.key,
  });

  @override
  State<MemberMembershipHistoryScreen> createState() =>
      _MemberMembershipHistoryScreenState();
}

class _MemberMembershipHistoryScreenState
    extends State<MemberMembershipHistoryScreen> {
  @override
  void initState() {
    super.initState();

    /*
     * Loads all memberships when the screen opens.
     *
     * No status is passed because this screen must show
     * all memberships belonging to the logged-in member.
     */
    context.read<MemberMembershipBloc>().add(
      const MemberMembershipStarted(),
    );
  }

  /*
   * Reloads all memberships.
   *
   * Used by:
   * - Pull-to-refresh
   * - Retry button
   */
  void _reloadMemberships() {
    context.read<MemberMembershipBloc>().add(
      const MemberMembershipRefreshed(),
    );
  }

  /*
   * Pull-to-refresh callback.
   *
   * The BLoC event starts a new request.
   */
  Future<void> _refreshMemberships() async {
    final MemberMembershipBloc bloc =
    context.read<MemberMembershipBloc>();

    bloc.add(
      const MemberMembershipRefreshed(),
    );

    /*
     * Wait until the request finishes.
     *
     * This allows RefreshIndicator to remain active until the BLoC
     * reaches either a loaded or error state.
     */
    await bloc.stream.firstWhere(
          (MemberMembershipState state) {
        return state is MemberMembershipLoaded ||
            state is MemberMembershipError;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens =
        context.watch<ThemeCubit>().state.tokens;

    final AppLocalizations l10n =
    AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      appBar: AppBar(
        backgroundColor: tokens.colors.surface,
        elevation: 0,
        surfaceTintColor: tokens.colors.surface,
        iconTheme: IconThemeData(
          color: tokens.colors.label,
        ),
        title: Text(
          l10n.accountMyMembership,
          style: tokens.typography.titleMedium.copyWith(
            color: tokens.colors.label,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MemberMembershipBloc,
            MemberMembershipState>(
          builder: (
              BuildContext context,
              MemberMembershipState state,
              ) {
            /*
             * Initial loading state.
             */
            if (state is MemberMembershipInitial ||
                state is MemberMembershipLoading) {
              return _MembershipLoadingView(
                tokens: tokens,
              );
            }

            /*
             * Successful response.
             */
            if (state is MemberMembershipLoaded) {
              if (state.memberships.isEmpty) {
                return _MembershipEmptyView(
                  tokens: tokens,
                  l10n: l10n,
                  onRefresh: _refreshMemberships,
                );
              }

              return RefreshIndicator(
                color: tokens.colors.primary,
                backgroundColor: tokens.colors.surface,
                onRefresh: _refreshMemberships,
                child: ListView.builder(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    tokens.spacing.lg,
                    tokens.spacing.lg,
                    tokens.spacing.lg,
                    tokens.spacing.xl,
                  ),
                  itemCount: state.memberships.length,
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return MemberMembershipCard(
                      membership: state.memberships[index],
                    );
                  },
                ),
              );
            }

            /*
             * Request failed.
             */
            if (state is MemberMembershipError) {
              return _MembershipErrorView(
                tokens: tokens,
                l10n: l10n,
                onRetry: _reloadMemberships,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/*
 * Initial loading UI.
 */
class _MembershipLoadingView extends StatelessWidget {
  final AppThemeTokens tokens;

  const _MembershipLoadingView({
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: tokens.colors.primary,
      ),
    );
  }
}

/*
 * Empty state displayed when the backend successfully returns:
 *
 * []
 *
 * The ListView is intentionally scrollable so pull-to-refresh
 * still works while there are no memberships.
 */
class _MembershipEmptyView extends StatelessWidget {
  final AppThemeTokens tokens;
  final AppLocalizations l10n;
  final Future<void> Function() onRefresh;

  const _MembershipEmptyView({
    required this.tokens,
    required this.l10n,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: tokens.colors.primary,
      backgroundColor: tokens.colors.surface,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(
          tokens.spacing.xl,
        ),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.18,
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_outlined,
              size: 40,
              color: tokens.colors.primary,
            ),
          ),
          SizedBox(
            height: tokens.spacing.lg,
          ),
          Text(
            l10n.memberMembershipEmptyTitle,
            textAlign: TextAlign.center,
            style: tokens.typography.titleMedium.copyWith(
              color: tokens.colors.label,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: tokens.spacing.sm,
          ),
          Text(
            l10n.memberMembershipEmptySubtitle,
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * Error UI displayed when the memberships request fails.
 */
class _MembershipErrorView extends StatelessWidget {
  final AppThemeTokens tokens;
  final AppLocalizations l10n;
  final VoidCallback onRetry;

  const _MembershipErrorView({
    required this.tokens,
    required this.l10n,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(
          tokens.spacing.xl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: tokens.colors.danger.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: tokens.colors.danger,
              ),
            ),
            SizedBox(
              height: tokens.spacing.lg,
            ),
            Text(
              l10n.memberMembershipLoadFailed,
              textAlign: TextAlign.center,
              style: tokens.typography.titleMedium.copyWith(
                color: tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: tokens.spacing.sm,
            ),
            Text(
              l10n.memberMembershipLoadFailedSubtitle,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: tokens.spacing.xl,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: Text(
                  l10n.retry,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    vertical: tokens.spacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      tokens.card.radius,
                    ),
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