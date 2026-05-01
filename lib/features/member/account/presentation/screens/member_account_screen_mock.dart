import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_stats_entity.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_profile_card_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_action_cards_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/referral_code_card_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_personal_info_widget.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/account_menu_section_widget.dart';

final _mockAccount = MemberAccountEntity(
  userId: 1,
  fullName: 'أحمد محمد السعيد',
  memberSince: 'يناير 2023',
  planName: 'الباقة الذهبية',
  profileFileId: null,
  email: 'ahmed.mohamed@email.com',
  phone: '+966 50 123 4567',
  dateOfBirth: '15 يناير 1990',
  address: 'الرياض، المملكة العربية السعودية',
  referralCode: 'AHMED2024',
  activeBookingsCount: 3,
  stats: const MemberAccountStatsEntity(
    sessionsCount: 12,
    exercisesCount: 24,
  ),
);

class MemberAccountScreenMock extends StatelessWidget {
  const MemberAccountScreenMock({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: tokens.colors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header with overlapping cards ──────────────────────
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
                        end: isRtl
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
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
                        AccountProfileCardWidget(account: _mockAccount),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -60,
                    left: tokens.spacing.lg,
                    right: tokens.spacing.lg,
                    child: AccountActionCardsWidget(account: _mockAccount),
                  ),
                ],
              ),

              const SizedBox(height: 76),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
                child: Column(
                  children: [
                    SizedBox(height: tokens.spacing.lg),
                    ReferralCodeCardWidget(
                        referralCode: _mockAccount.referralCode),
                    SizedBox(height: tokens.spacing.lg),
                    AccountPersonalInfoWidget(
                      account: _mockAccount,
                      onEditTap: () {},
                    ),
                    SizedBox(height: tokens.spacing.lg),
                    AccountMenuSectionWidget(
                      title: l10n.accountSectionAccount,
                      items: [
                        AccountMenuItem(
                          icon: Icons.edit_rounded,
                          label: l10n.accountEditProfile,
                          onTap: () {},
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
                          onTap: () => _showLogoutDialog(context, l10n, tokens),
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
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n, dynamic tokens) {
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
            onPressed: () => Navigator.pop(context),
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