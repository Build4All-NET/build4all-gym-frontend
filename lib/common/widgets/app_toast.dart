// ─────────────────────────────────────────────────────────────────────────────
// lib/common/widgets/app_toast.dart
//
// PURPOSE:
//   Centralised utility for showing themed SnackBar notifications.
//   The three public methods (success, error, info) are the ONLY way the app
//   should display transient user feedback. Never use ScaffoldMessenger directly
//   in screens — use AppToast instead so styling stays consistent.
//
// HOW IT WORKS:
//   1. Reads the current ThemeCubit colours to pick background/foreground.
//   2. Passes the raw message/error object through ExceptionMapper.toMessage()
//      which cleans and humanises it before display.
//   3. Clears any existing snackbar first (clearSnackBars) to avoid stacking.
//
// RELATIONSHIPS:
//   ▶ Reads from:  ThemeCubit (colors.primary, colors.error, colors.onPrimary)
//   ▶ Uses:        ExceptionMapper.toMessage() for error humanisation
//   ◀ Called by:   Every screen with user feedback (forgot password screens,
//                  login, register, profile…)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme_cubit.dart';
import '../../core/exceptions/exception_mapper.dart';

/// Controls which colour palette is applied to the snackbar.
enum AppToastType { success, error, info }

class AppToast {
  // ── PRIVATE CORE ──────────────────────────────────────────────────────────

  /// Internal method that builds and shows the SnackBar.
  /// All three public methods delegate here.
  static void _show(
      BuildContext context,
      Object message, {
        required AppToastType type,
      }) {
    // Read current theme colours synchronously (read, not watch — this is
    // a one-shot call, not a widget rebuild)
    final themeState = context.read<ThemeCubit>().state;
    final colors = themeState.tokens.colors;

    // Convert any error/string/exception into a clean, readable message
    final clean = ExceptionMapper.toMessage(message);

    // Pick background and text colours based on toast type
    Color bg;
    Color fg;
    switch (type) {
      case AppToastType.error:
        bg = colors.error;       // Red-ish from theme
        fg = colors.onPrimary;   // Contrasting text
        break;
      case AppToastType.success:
        bg = colors.primary;     // Brand colour for positive feedback
        fg = colors.onPrimary;
        break;
      case AppToastType.info:
        bg = colors.primary;     // Same as success — differentiate if needed
        fg = colors.onPrimary;
        break;
    }

    final messenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbar before showing the new one
    // Prevents multiple toasts stacking on rapid button taps
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            clean,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating, // floats above nav bar
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ── PUBLIC API ────────────────────────────────────────────────────────────

  /// Shows a green/primary-coloured success toast.
  /// Pass the backend message string directly.
  static void success(BuildContext context, Object message) {
    _show(context, message, type: AppToastType.success);
  }

  /// Shows a red error toast.
  /// Pass any exception, string, or error object — ExceptionMapper cleans it.
  static void error(BuildContext context, Object error) {
    _show(context, error, type: AppToastType.error);
  }

  /// Shows a neutral info toast (same colour as success by default).
  static void info(BuildContext context, Object message) {
    _show(context, message, type: AppToastType.info);
  }
}