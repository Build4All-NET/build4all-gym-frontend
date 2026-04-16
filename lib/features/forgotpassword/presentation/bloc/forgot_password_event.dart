// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/bloc/forgot_password_event.dart
//
// PURPOSE:
//   Defines every action (event) the UI can fire at the BLoC.
//   In BLoC pattern, events are the INPUT — the UI fires them, the BLoC reacts.
//
// EVENTS:
//   ForgotSendCodePressed     → Screen 1 "Send OTP" button / Screen 2 "Resend"
//   ForgotVerifyCodePressed   → Screen 2 "Verify" button
//   ForgotUpdatePasswordPressed → Screen 3 "Save Password" button
//   ForgotClearMessage        → fired right after navigation to reset state
//
// RELATIONSHIPS:
//   ◀ Fired by:    ForgotPasswordEmailScreen, ForgotPasswordVerifyScreen,
//                  ForgotPasswordNewPasswordScreen
//   ▶ Handled by:  ForgotPasswordBloc (on<> registrations)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

/// Base class for all forgot-password events.
/// Equatable ensures BLoC doesn't process identical consecutive events twice.
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

// ── STEP 1 ────────────────────────────────────────────────────────────────────

/// Fired when the user taps "Send OTP" on Screen 1, OR "Resend" on Screen 2.
/// The same event covers both cases — the backend handles resend automatically.
class ForgotSendCodePressed extends ForgotPasswordEvent {
  /// The email address to send the OTP to.
  final String email;

  /// Identifies which gym's backend to use.
  final int ownerProjectLinkId;

  const ForgotSendCodePressed({
    required this.email,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [email, ownerProjectLinkId];
}

// ── STEP 2 ────────────────────────────────────────────────────────────────────

/// Fired when the user taps "Verify" on Screen 2.
class ForgotVerifyCodePressed extends ForgotPasswordEvent {
  /// The email address — needed again because the backend is stateless.
  final String email;

  /// The OTP code the user typed.
  final String code;

  final int ownerProjectLinkId;

  const ForgotVerifyCodePressed({
    required this.email,
    required this.code,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [email, code, ownerProjectLinkId];
}

// ── STEP 3 ────────────────────────────────────────────────────────────────────

/// Fired when the user taps "Save Password" on Screen 3.
class ForgotUpdatePasswordPressed extends ForgotPasswordEvent {
  final String email;

  /// The OTP code — carried from Screen 2 to Screen 3 via constructor param.
  final String code;

  /// The new password the user wants to set.
  final String newPassword;

  final int ownerProjectLinkId;

  const ForgotUpdatePasswordPressed({
    required this.email,
    required this.code,
    required this.newPassword,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [email, code, newPassword, ownerProjectLinkId];
}

// ── UTILITY ───────────────────────────────────────────────────────────────────

/// Fired immediately after navigating forward, to clear successMessage/error.
/// Without this, pressing the back button would retrigger the listener and
/// navigate again or show a stale toast.
class ForgotClearMessage extends ForgotPasswordEvent {
  const ForgotClearMessage();
}