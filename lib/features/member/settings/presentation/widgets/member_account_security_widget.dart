// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/presentation/widgets/member_account_security_widget.dart
//
// PURPOSE:
//   Member version of the Account & Security section.
//   Contains only member security preferences.
//
// ROWS:
//   1. Biometric Login → toggle (reads/writes from MemberSettingsCubit)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../cubit/member_settings_cubit.dart';

class MemberAccountSecurityWidget extends StatelessWidget {
  const MemberAccountSecurityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final state = context.watch<MemberSettingsCubit>().state;
    final cubit = context.read<MemberSettingsCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: c.success,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account & Security',
                      style: tokens.typography.titleMedium,
                    ),
                    Text(
                      'Manage your account security',
                      style: tokens.typography.bodySmall.copyWith(
                        color: c.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: c.border.withOpacity(0.2)),

          // Biometric Login row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android_rounded,
                  color: c.muted,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biometric Login',
                        style: tokens.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Use fingerprint or face ID',
                        style: tokens.typography.bodySmall.copyWith(
                          color: c.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.isBiometricEnabled,
                  onChanged: cubit.setBiometricEnabled,
                  activeColor: c.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}