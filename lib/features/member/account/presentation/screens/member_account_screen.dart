import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/app/app_router.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';

import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_bloc.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_event.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_state.dart';
import 'package:build4allgym/features/member/account/presentation/screens/member_edit_profile_screen.dart';
import 'package:build4allgym/features/member/account/presentation/screens/member_my_info_screen.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_action_cards_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_menu_section_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_personal_info_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_profile_card_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/referral_code_card_widget.dart';

import 'package:build4allgym/features/member/build4all_profile/domain/entities/member_build4all_profile_entity.dart';
import 'package:build4allgym/features/member/build4all_profile/presentation/bloc/member_build4all_profile_bloc.dart';
import 'package:build4allgym/features/member/build4all_profile/presentation/bloc/member_build4all_profile_event.dart';
import 'package:build4allgym/features/member/build4all_profile/presentation/bloc/member_build4all_profile_state.dart';

/*
 * Membership history feature imports.
 */
import 'package:build4allgym/features/member/membership_history/data/repositories/member_membership_repository_impl.dart';
import 'package:build4allgym/features/member/membership_history/data/services/member_membership_service.dart';
import 'package:build4allgym/features/member/membership_history/domain/usecases/get_member_memberships_usecase.dart';
import 'package:build4allgym/features/member/membership_history/presentation/bloc/member_membership_bloc.dart';
import 'package:build4allgym/features/member/membership_history/presentation/screens/member_membership_history_screen.dart';

class MemberAccountScreen extends StatefulWidget {
  final MemberAccountBloc bloc;

  const MemberAccountScreen({
    super.key,
    required this.bloc,
  });

  @override
  State<MemberAccountScreen> createState() =>
      _MemberAccountScreenState();
}

class _MemberAccountScreenState
    extends State<MemberAccountScreen> {
  @override
  void initState() {
    super.initState();

    widget.bloc.add(
      const MemberAccountStarted(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        context.read<ThemeCubit>().state.tokens;

    final l10n =
    AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        backgroundColor: tokens.colors.background,
        body: BlocListener<MemberAccountBloc,
            MemberAccountState>(
          listener: (
              BuildContext context,
              MemberAccountState state,
              ) {
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.accountProfileUpdateSuccess,
                  ),
                  backgroundColor:
                  tokens.colors.success,
                  behavior:
                  SnackBarBehavior.floating,
                ),
              );
            }

            if (state is ProfileUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor:
                  tokens.colors.danger,
                  behavior:
                  SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<MemberAccountBloc,
              MemberAccountState>(
            builder: (
                BuildContext context,
                MemberAccountState accountState,
                ) {
              return BlocBuilder<
                  MemberBuild4AllProfileBloc,
                  MemberBuild4AllProfileState>(
                builder: (
                    BuildContext context,
                    MemberBuild4AllProfileState
                    profileState,
                    ) {
                  if (accountState
                  is MemberAccountLoading ||
                      profileState
                      is MemberBuild4AllProfileLoading ||
                      accountState
                      is MemberAccountInitial ||
                      profileState
                      is MemberBuild4AllProfileInitial) {
                    return Center(
                      child: CircularProgressIndicator(
                        color:
                        tokens.colors.primary,
                      ),
                    );
                  }

                  if (accountState
                  is MemberAccountError) {
                    return _AccountErrorView(
                      message:
                      accountState.message,
                      onRetry: () {
                        context
                            .read<
                            MemberAccountBloc>()
                            .add(
                          const MemberAccountStarted(),
                        );

                        context
                            .read<
                            MemberBuild4AllProfileBloc>()
                            .add(
                          const MemberBuild4AllProfileRefreshRequested(),
                        );
                      },
                    );
                  }

                  if (profileState
                  is MemberBuild4AllProfileError) {
                    return _AccountErrorView(
                      message:
                      profileState.message,
                      onRetry: () {
                        context
                            .read<
                            MemberAccountBloc>()
                            .add(
                          const MemberAccountStarted(),
                        );

                        context
                            .read<
                            MemberBuild4AllProfileBloc>()
                            .add(
                          const MemberBuild4AllProfileRefreshRequested(),
                        );
                      },
                    );
                  }

                  if (accountState
                  is MemberAccountLoaded &&
                      profileState
                      is MemberBuild4AllProfileLoaded) {
                    return _AccountBody(
                      account:
                      accountState.account,
                      profile:
                      profileState.profile,
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color:
                      tokens.colors.primary,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AccountErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AccountErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final tokens =
        context.read<ThemeCubit>().state.tokens;

    final l10n =
    AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          tokens.spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: tokens.colors.danger,
              size: 48,
            ),
            SizedBox(
              height: tokens.spacing.md,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
              tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.danger,
              ),
            ),
            SizedBox(
              height: tokens.spacing.lg,
            ),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                tokens.colors.primary,
                foregroundColor:
                tokens.colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    tokens.button.radius,
                  ),
                ),
              ),
              child: Text(
                l10n.retry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountBody extends StatelessWidget {
  final MemberAccountEntity account;
  final MemberBuild4AllProfileEntity profile;

  const _AccountBody({
    required this.account,
    required this.profile,
  });

  /*
   * Opens the profile editing screen.
   */
  void _openEditProfile(
      BuildContext context,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value:
              context.read<MemberAccountBloc>(),
            ),
            BlocProvider.value(
              value: context.read<
                  MemberBuild4AllProfileBloc>(),
            ),
          ],
          child: MemberEditProfileScreen(
            account: account,
            profile: profile,
          ),
        ),
      ),
    );
  }

  /*
   * Opens the member My Info screen.
   */
  void _openMyInfo(
      BuildContext context,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const MemberMyInfoScreen(),
      ),
    );
  }

  /*
   * Opens the membership history screen.
   *
   * Dependencies are created here because this screen is opened
   * only from the My Membership item inside My Account.
   *
   * Flow:
   *
   * MemberMembershipBloc
   * -> GetMemberMembershipsUseCase
   * -> MemberMembershipRepositoryImpl
   * -> MemberMembershipService
   */
  void _openMembershipHistory(
      BuildContext context,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          final MemberMembershipService service =
          MemberMembershipService();

          final MemberMembershipRepositoryImpl
          repository =
          MemberMembershipRepositoryImpl(
            service,
          );

          final GetMemberMembershipsUseCase
          useCase =
          GetMemberMembershipsUseCase(
            repository,
          );

          return BlocProvider<
              MemberMembershipBloc>(
            create: (_) =>
                MemberMembershipBloc(
                  getMemberMembershipsUseCase:
                  useCase,
                ),
            child:
            const MemberMembershipHistoryScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        context.read<ThemeCubit>().state.tokens;

    final l10n =
    AppLocalizations.of(context)!;

    final bool isRtl =
        Directionality.of(context) ==
            TextDirection.rtl;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding:
                EdgeInsetsDirectional.fromSTEB(
                  tokens.spacing.lg,
                  MediaQuery.of(context)
                      .padding
                      .top +
                      24,
                  tokens.spacing.lg,
                  80,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: isRtl
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    end: isRtl
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    colors: [
                      tokens.colors.primary,
                      tokens.colors.success,
                    ],
                  ),
                  borderRadius:
                  const BorderRadiusDirectional
                      .only(
                    bottomStart:
                    Radius.circular(28),
                    bottomEnd:
                    Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.stretch
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.memberBottomNavAccount,
                      textAlign: isRtl
                          ? TextAlign.right
                          : TextAlign.left,
                      style: tokens
                          .typography.headlineSmall
                          .copyWith(
                        color: tokens
                            .colors.onPrimary,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: tokens.spacing.lg,
                    ),
                    AccountProfileCardWidget(
                      account: account,
                      profile: profile,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -50,
                left: tokens.spacing.lg,
                right: tokens.spacing.lg,
                child:
                AccountActionCardsWidget(
                  account: account,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.lg,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: tokens.spacing.lg,
                ),
                ReferralCodeCardWidget(
                  referralCode:
                  account.referralCode,
                ),
                SizedBox(
                  height: tokens.spacing.lg,
                ),
                AccountPersonalInfoWidget(
                  account: account,
                  profile: profile,
                ),
                SizedBox(
                  height: tokens.spacing.lg,
                ),
                AccountMenuSectionWidget(
                  title:
                  l10n.accountSectionAccount,
                  items: [
                    AccountMenuItem(
                      icon: Icons.edit_rounded,
                      label:
                      l10n.accountEditProfile,
                      onTap: () =>
                          _openEditProfile(
                            context,
                          ),
                    ),
                    AccountMenuItem(
                      icon: Icons
                          .info_outline_rounded,
                      label:
                      l10n.accountMyInfo,
                      onTap: () => _openMyInfo(
                        context,
                      ),
                    ),
                    AccountMenuItem(
                      icon: Icons
                          .workspace_premium_rounded,
                      label: l10n
                          .accountMyMembership,
                      onTap: () =>
                          _openMembershipHistory(
                            context,
                          ),
                    ),
                    AccountMenuItem(
                      icon: Icons
                          .auto_awesome_rounded,
                      label: l10n.accountAskAi,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(
                          AppRouter.memberAiAssistant,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: tokens.spacing.lg,
                ),
                AccountMenuSectionWidget(
                  title:
                  l10n.accountSectionSettings,
                  items: [
                    AccountMenuItem(
                      icon: Icons
                          .notifications_rounded,
                      label: l10n
                          .accountNotifications,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon:
                      Icons.settings_rounded,
                      label:
                      l10n.accountSettings,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(
                          AppRouter.userSettings,
                        );
                      },
                    ),
                    AccountMenuItem(
                      icon: Icons
                          .help_outline_rounded,
                      label:
                      l10n.accountHelpSupport,
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: tokens.spacing.md,
                ),
                AccountMenuSectionWidget(
                  title: '',
                  items: [
                    AccountMenuItem(
                      icon:
                      Icons.logout_rounded,
                      label: l10n.navLogout,
                      onTap: () =>
                          _showLogoutDialog(
                            context,
                          ),
                      labelColor:
                      tokens.colors.danger,
                      iconColor:
                      tokens.colors.danger,
                      iconBgColor: tokens
                          .colors.danger
                          .withOpacity(0.1),
                    ),
                  ],
                ),
                SizedBox(
                  height: tokens.spacing.lg,
                ),
                Center(
                  child: Text(
                    '${l10n.appVersion} 1.0.0',
                    style: tokens
                        .typography.bodySmall
                        .copyWith(
                      color:
                      tokens.colors.muted,
                    ),
                  ),
                ),
                SizedBox(
                  height: tokens.spacing.xl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context,
      ) {
    final tokens =
        context.read<ThemeCubit>().state.tokens;

    final l10n =
    AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          l10n.logoutConfirmTitle,
        ),
        content: Text(
          l10n.logoutConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text(
              l10n.general_cancel,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              context
                  .read<AuthBloc>()
                  .add(
                const AuthLoggedOut(),
              );
            },
            child: Text(
              l10n.navLogout,
              style: TextStyle(
                color: tokens.colors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}