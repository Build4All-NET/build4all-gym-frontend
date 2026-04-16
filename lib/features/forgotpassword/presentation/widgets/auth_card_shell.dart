// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/widgets/auth_card_shell.dart
//
// PURPOSE:
//   Shared layout shell used by all three forgot-password screens (and
//   potentially the login/register screens too). Provides:
//     - A centred, scrollable single-column layout
//     - A themed circular icon at the top
//     - A title + subtitle
//     - A themed card container that wraps the screen's form content
//
//   Screens pass their form as [child] — the shell handles everything else.
//   This keeps the actual screen files focused on form logic only.
//
// RELATIONSHIPS:
//   ◀ Used by:    ForgotPasswordEmailScreen, ForgotPasswordVerifyScreen,
//                 ForgotPasswordNewPasswordScreen
//   ▶ Reads from: ThemeCubit (colors, card tokens for radius/padding/shadow)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';

class AuthCardShell extends StatelessWidget {
  /// The form content rendered inside the themed card.
  final Widget child;

  /// Bold heading shown below the icon (e.g. "Reset your password").
  final String title;

  /// Descriptive sub-text below the title (e.g. "Enter your email to continue").
  final String subtitle;

  /// Icon displayed in the circular badge at the top. Defaults to lock-reset.
  final IconData icon;

  const AuthCardShell({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_reset,
  });

  @override
  Widget build(BuildContext context) {
    // Pull design tokens from the active remote/fallback theme
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final colors = tokens.colors;
    final card = tokens.card;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Horizontal padding keeps content from touching screen edges
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon badge ────────────────────────────────────────────
                CircleAvatar(
                  radius: 28,
                  // Light-tinted version of the primary colour as background
                  backgroundColor: colors.primary.withOpacity(0.1),
                  child: Icon(icon, color: colors.primary, size: 28),
                ),
                const SizedBox(height: 12),

                // ── Title ────────────────────────────────────────────────
                Text(
                  title,
                  style: t.titleLarge?.copyWith(
                    color: colors.label,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),

                // ── Subtitle ─────────────────────────────────────────────
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: colors.body),
                ),
                const SizedBox(height: 22),

                // ── Card container ────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(card.padding),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(card.radius),
                    // Border is optional — controlled by the theme token
                    border: card.showBorder
                        ? Border.all(
                      color: colors.border.withOpacity(0.15),
                    )
                        : null,
                    // Shadow is optional — controlled by the theme token
                    boxShadow: card.showShadow
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: card.elevation * 2,
                        offset: Offset(0, card.elevation * 0.6),
                      ),
                    ]
                        : null,
                  ),
                  // The screen passes its form as child — shell is layout-only
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}