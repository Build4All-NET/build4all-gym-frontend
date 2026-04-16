// ─────────────────────────────────────────────────────────────────────────────
//
// PURPOSE:
//   Use case for Step 1 of the forgot-password flow.
//   A use case has exactly ONE job: encapsulate a single business action.
//   This one says "send a reset OTP to this email".
//
// WHY HAVE A USE CASE AT ALL:
//   The BLoC could call the repository directly, but use cases let you add
//   business logic (e.g. email validation, rate limiting) in one place without
//   touching the BLoC or the repository.
//
// RELATIONSHIPS:
//   ▶ Depends on:  ForgotPasswordRepository (injected, abstract)
//   ◀ Called by:   ForgotPasswordBloc._onSend()
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/forgot_password_entity.dart';
import '../repositories/forgot_password_repository.dart';

class SendResetCode {
  /// Abstract repository — injected so this use case is testable without HTTP.
  final ForgotPasswordRepository repo;

  SendResetCode(this.repo);

  /// Executes the use case.
  /// Passes [email] and [ownerProjectLinkId] to the repository.
  /// Returns [ForgotPasswordResult] on success; throws on failure.
  Future<ForgotPasswordResult> call({
    required String email,
    required int ownerProjectLinkId,
  }) {
    return repo.sendResetCode(
      email: email,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}