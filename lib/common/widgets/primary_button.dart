// ─────────────────────────────────────────────────────────────────────────────
// lib/common/widgets/primary_button.dart
//
// PURPOSE:
//   Reusable call-to-action button used across the entire app.
//   Reads all sizing and colour values from ThemeCubit so it automatically
//   adapts to any gym's remote theme without code changes.
//
// LOADING STATE:
//   When isLoading = true, the label is replaced with a small spinner AND
//   the button is disabled (onPressed set to null). This prevents double-taps
//   while an API call is in flight.
//
// RELATIONSHIPS:
//   ◀ Used by:    Every screen that has a submit action (forgot password,
//                 login, register, profile, checkout…)
//   ▶ Reads from: ThemeCubit (colors.primary, colors.onPrimary,
//                 button.height, button.radius, button.fullWidth, button.textSize)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme_cubit.dart';

class PrimaryButton extends StatelessWidget {
  /// Text shown on the button when not loading.
  final String label;

  /// Action triggered on tap. Pass null to disable the button permanently.
  final VoidCallback? onPressed;

  /// When true, replaces the label with a spinner and disables tapping.
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Pull all sizing/colour tokens from the active theme
    final themeState = context.watch<ThemeCubit>().state;
    final colors = themeState.tokens.colors;
    final button = themeState.tokens.button;
    final textTheme = Theme.of(context).textTheme;

    // Switch between spinner and label based on loading state
    final child = isLoading
        ? const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    )
        : Text(
      label,
      style: textTheme.bodyMedium?.copyWith(
        color: colors.onPrimary,
        fontSize: button.textSize,
        fontWeight: FontWeight.w600,
      ),
    );

    return SizedBox(
      // fullWidth token controls whether the button stretches to fill the row
      width: button.fullWidth ? double.infinity : null,
      height: button.height,
      child: ElevatedButton(
        // Disable the button while loading to prevent double-submission
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(button.radius),
          ),
        ),
        child: child,
      ),
    );
  }
}