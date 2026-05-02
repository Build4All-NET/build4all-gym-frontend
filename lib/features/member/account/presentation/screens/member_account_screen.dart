import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_bloc.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_event.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_state.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_profile_card_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_action_cards_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/referral_code_card_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_personal_info_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_menu_section_widget.dart';

class MemberAccountScreen extends StatefulWidget {
  final MemberAccountBloc bloc;

  const MemberAccountScreen({super.key, required this.bloc});

  @override
  State<MemberAccountScreen> createState() => _MemberAccountScreenState();
}

class _MemberAccountScreenState extends State<MemberAccountScreen> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(const MemberAccountStarted());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider.value(
      value: widget.bloc,
      child: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: tokens.colors.background,
          body: BlocConsumer<MemberAccountBloc, MemberAccountState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.accountProfileUpdateSuccess),
                    backgroundColor: tokens.colors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              if (state is ProfileUpdateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: tokens.colors.danger,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is MemberAccountLoading) {
                return Center(
                  child: CircularProgressIndicator(
                      color: tokens.colors.primary),
                );
              }

              if (state is MemberAccountError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.spacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            color: tokens.colors.danger, size: 48),
                        SizedBox(height: tokens.spacing.md),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: tokens.typography.bodyMedium
                              .copyWith(color: tokens.colors.danger),
                        ),
                        SizedBox(height: tokens.spacing.lg),
                        ElevatedButton(
                          onPressed: () => context
                              .read<MemberAccountBloc>()
                              .add(const MemberAccountStarted()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tokens.colors.primary,
                            foregroundColor: tokens.colors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  tokens.button.radius),
                            ),
                          ),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is MemberAccountLoaded) {
                return _AccountBody(account: state.account);
              }

              return Center(
                child: CircularProgressIndicator(
                    color: tokens.colors.primary),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AccountBody extends StatelessWidget {
  final MemberAccountEntity account;

  const _AccountBody({required this.account});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header with overlapping cards ──────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(
                  tokens.spacing.lg,
                  MediaQuery.of(context).padding.top + 24,
                  tokens.spacing.lg,
                  80,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: isRtl ? Alignment.topRight : Alignment.topLeft,
                    end: isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
                    colors: [tokens.colors.primary, tokens.colors.success],
                  ),
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(28),
                    bottomEnd: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.memberBottomNavAccount,
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      style: tokens.typography.headlineSmall.copyWith(
                        color: tokens.colors.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: tokens.spacing.lg),
                    AccountProfileCardWidget(account: account),
                  ],
                ),
              ),
              Positioned(
                bottom: -60,
                left: tokens.spacing.lg,
                right: tokens.spacing.lg,
                child: AccountActionCardsWidget(account: account),
              ),
            ],
          ),

          const SizedBox(height: 76),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
            child: Column(
              children: [
                SizedBox(height: tokens.spacing.lg),
                ReferralCodeCardWidget(referralCode: account.referralCode),
                SizedBox(height: tokens.spacing.lg),
                AccountPersonalInfoWidget(
                  account: account,
                  onEditTap: () {
                    // TODO: Navigate to edit profile screen
                  },
                ),
                SizedBox(height: tokens.spacing.lg),
                AccountMenuSectionWidget(
                  title: l10n.accountSectionAccount,
                  items: [
                    AccountMenuItem(
                      icon: Icons.edit_rounded,
                      label: l10n.accountEditProfile,
                      onTap: () {
                        // TODO: Navigate to edit profile screen
                      },
                    ),
                    AccountMenuItem(
                      icon: Icons.credit_card_rounded,
                      label: l10n.accountPaymentMethods,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.workspace_premium_rounded,
                      label: l10n.accountMyMembership,
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.lg),
                AccountMenuSectionWidget(
                  title: l10n.accountSectionSettings,
                  items: [
                    AccountMenuItem(
                      icon: Icons.notifications_rounded,
                      label: l10n.accountNotifications,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.settings_rounded,
                      label: l10n.accountSettings,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.help_outline_rounded,
                      label: l10n.accountHelpSupport,
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.md),
                AccountMenuSectionWidget(
                  title: '',
                  items: [
                    AccountMenuItem(
                      icon: Icons.logout_rounded,
                      label: l10n.navLogout,
                      onTap: () => _showLogoutDialog(context),
                      labelColor: tokens.colors.danger,
                      iconColor: tokens.colors.danger,
                      iconBgColor: tokens.colors.danger.withOpacity(0.1),
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.lg),
                Center(
                  child: Text(
                    '${l10n.appVersion} 1.0.0',
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.muted,
                    ),
                  ),
                ),
                SizedBox(height: tokens.spacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLoggedOut());
            },
            child: Text(
              l10n.navLogout,
              style: TextStyle(color: tokens.colors.danger),
            ),
          ),
        ],
      ),
    );
  }
}