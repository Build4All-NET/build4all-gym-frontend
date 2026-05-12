// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/presentation/widgets/account_security_section_widget.dart
//
// PURPOSE:
//   Renders the "Account & Security" settings card with 3 rows:
//     1. Change Password   → navigates to ForgotPasswordEmailScreen
//     2. Biometric Login   → toggle (ON by default per Figma)
//     3. Two-Factor Auth   → toggle (OFF by default per Figma)
//
// AUTH BACKEND SCOPE:
//   All auth-related calls go to Env.apiBaseUrl (the build4all platform backend).
//   The 2FA endpoint is NOT yet available — it's stubbed with a TODO.
//
// DESIGN (matches Figma):
//   Green lock icon header. White card. Rows separated by thin dividers.
//   Each row: icon | label + subtitle | toggle or chevron
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/app_router.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../cubit/admin_settings_cubit.dart';
import '../cubit/admin_settings_state.dart';

class AccountSecuritySectionWidget extends StatelessWidget {
  const AccountSecuritySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    // Read cubit state for toggle values
    final state = context.watch<AdminSettingsCubit>().state;
    final cubit = context.read<AdminSettingsCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          // ── Section header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Green lock icon (tokens.colors.success tinted container)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.lock_rounded, color: c.success, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account & Security',
                        style: tokens.typography.titleMedium),
                    Text('Manage your account security',
                        style: tokens.typography.bodySmall.copyWith(color: c.muted)),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: c.border.withOpacity(0.2)),

          // ── Row 1: Change Password ─────────────────────────────────────────
          // This is a navigation action, NOT a dirty-tracked setting.
          // Tapping navigates to the existing ForgotPasswordEmailScreen (reused).
          _SettingsRow(
            icon: Icons.key_rounded,
            label: 'Change Password',
            subtitle: 'Update your account password',
            trailing: Icon(Icons.chevron_right_rounded,
                color: c.muted, size: 22),
            onTap: () => Navigator.of(context).pushNamed(AppRouter.forgotPassword),
            tokens: tokens,
          ),

          Divider(height: 1, color: c.border.withOpacity(0.2)),

          // ── Row 2: Biometric Login ─────────────────────────────────────────
          // UI preference only — actual biometric prompt integration is out of scope.
          // Value is persisted to FlutterSecureStorage on "Save Changes".
          _SettingsRow(
            icon: Icons.phone_android_rounded,
            label: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            trailing: Switch(
              value: state.isBiometricEnabled,
              onChanged: (v) => cubit.setBiometricEnabled(v),
              activeColor: c.primary,
            ),
            tokens: tokens,
          ),

          Divider(height: 1, color: c.border.withOpacity(0.2)),

          // ── Row 3: Two-Factor Authentication ──────────────────────────────
          // TODO: Call DELETE Env.apiBaseUrl + '/api/v1/auth/2fa/toggle' on Save
          //       when the build4all platform team confirms the endpoint.
          _SettingsRow(
            icon: Icons.shield_outlined,
            label: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security',
            trailing: Switch(
              value: state.isTwoFactorEnabled,
              onChanged: (v) => cubit.setTwoFactorEnabled(v),
              activeColor: c.primary,
            ),
            tokens: tokens,
          ),
        ],
      ),
    );
  }
}

// ─── Private reusable row widget ──────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final dynamic tokens;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.trailing,
    required this.tokens,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(tokens.card.radius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: c.muted, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: tokens.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: tokens.typography.bodySmall.copyWith(color: c.muted)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
