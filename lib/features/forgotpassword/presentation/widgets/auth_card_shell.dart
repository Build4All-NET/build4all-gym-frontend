import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';

// The card wrapper used by ALL 3 screens.
// Uses ThemeCubit — so the colors automatically match
class AuthCardShell extends StatelessWidget {
  final Widget child;    // the form that goes inside the card
  final String title;    // big title like "Reset your password"
  final String subtitle; // small text under the title
  final IconData icon;   // the circle icon at the top

  const AuthCardShell({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_reset,
  });

  @override
  Widget build(BuildContext context) {
    // Get the theme tokens from ThemeCubit
    // tokens.colors.primary = the app's primary colorS
    // tokens.card.radius = the card corner radius
    // tokens.card.padding = padding inside the card
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final colors = tokens.colors;
    final card = tokens.card;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      // Use the background color from the theme tokens
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Circle icon at top
                // Color comes from theme — automatically pink/green/etc
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colors.primary.withOpacity(0.12),
                  child: Icon(icon, color: colors.primary, size: 30),
                ),
                const SizedBox(height: 14),

                // Title — uses textTheme from ThemeData
                // (set in AppThemeBuilder → text.headlineSmall)
                Text(
                  title,
                  style: t.titleLarge?.copyWith(
                    color: colors.label,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle — uses bodyMedium from textTheme
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: colors.body),
                ),
                const SizedBox(height: 24),

                // White card that wraps the form
                // Uses card.radius and card.padding from tokens
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(card.padding + 8),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(card.radius),
                    border: card.showBorder
                        ? Border.all(
                        color: colors.border.withOpacity(0.15))
                        : null,
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