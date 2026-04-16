// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/bloc/forgot_password_state.dart
//
// PURPOSE:
//   Represents the current UI state of the entire forgot-password flow.
//   All three screens share ONE BLoC instance and therefore ONE state object.
//   In BLoC pattern, state is the OUTPUT — the UI rebuilds whenever it changes.
//
// FIELDS:
//   isLoading      → true while an API call is in flight (shows spinner)
//   successMessage → set when an API call succeeds (triggers navigation/toast)
//   error          → set when an API call fails (triggers error toast)
//
// PATTERN — copyWith + clearSuccess/clearError flags:
//   Rather than setting fields to null directly, the BLoC passes
//   clearSuccess: true or clearError: true so the intent is explicit and
//   readable in the BLoC code.
//
// RELATIONSHIPS:
//   ◀ Emitted by:  ForgotPasswordBloc
//   ◀ Consumed by: ForgotPasswordEmailScreen, ForgotPasswordVerifyScreen,
//                  ForgotPasswordNewPasswordScreen (via BlocConsumer)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  /// Whether an API call is currently in progress.
  /// Used to disable the button and show a loading spinner.
  final bool isLoading;

  /// The success message returned by the backend on a successful step.
  /// When non-null, the screen's listener navigates forward and shows a toast.
  /// Cleared immediately after via ForgotClearMessage to avoid re-triggering.
  final String? successMessage;

  /// The exception thrown on a failed API call.
  /// Passed to ExceptionMapper.toMessage() to produce a user-readable string.
  final Object? error;

  const ForgotPasswordState({
    required this.isLoading,
    this.successMessage,
    this.error,
  });

  /// Starting state: not loading, no message, no error.
  factory ForgotPasswordState.initial() =>
      const ForgotPasswordState(isLoading: false);

  /// Returns a new state with only the specified fields changed.
  /// [clearSuccess] and [clearError] set the corresponding fields to null
  /// rather than needing to pass null explicitly, which improves readability.
  ForgotPasswordState copyWith({
    bool? isLoading,
    String? successMessage,
    Object? error,
    bool clearSuccess = false,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      // If clearSuccess is true → null; otherwise use new value or keep old
      successMessage:
      clearSuccess ? null : (successMessage ?? this.successMessage),
      // If clearError is true → null; otherwise use new value or keep old
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [isLoading, successMessage, error];
}