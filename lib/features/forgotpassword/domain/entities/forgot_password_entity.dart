// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/domain/entities/forgot_password_entity.dart
//
// PURPOSE:
//   Pure domain entity — the single result type that flows from the repository
//   up through use cases to the BLoC. Contains ONLY what the app logic needs;
//   no JSON, no HTTP, no Flutter imports.
//
// WHY SO SIMPLE:
//   All three forgot-password steps return only a success message from the
//   backend. There is no token, no UUID, no extra data — the email and code
//   are passed between screens directly via constructor params, not stored here.
//
// RELATIONSHIPS:
//   ◀ Returned by: ForgotPasswordRepository (all 3 methods)
//   ◀ Produced by: ForgotPasswordRepositoryImpl (converts ForgotMessageResponse)
//   ◀ Consumed by: SendResetCode, VerifyResetCode, UpdatePassword use cases
//   ◀ Used in:     ForgotPasswordBloc → stored as state.successMessage
// ─────────────────────────────────────────────────────────────────────────────

/// Represents the successful result of any forgot-password operation.
/// The [message] is shown to the user as a success toast.
class ForgotPasswordResult {
  /// Backend success message (e.g. "OTP sent successfully").
  final String message;

  const ForgotPasswordResult({required this.message});
}