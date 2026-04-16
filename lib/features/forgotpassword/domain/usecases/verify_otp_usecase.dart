// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/domain/usecases/verify_otp_usecase.dart
//
// PURPOSE:
//   Use case for Step 2 of the forgot-password flow.
//   One job: verify the OTP code the user entered.
//
// RELATIONSHIPS:
//   ▶ Depends on:  ForgotPasswordRepository (injected, abstract)
//   ◀ Called by:   ForgotPasswordBloc._onVerify()
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/forgot_password_entity.dart';
import '../repositories/forgot_password_repository.dart';

class VerifyResetCode {
  /// Abstract repository — injected so this use case is testable without HTTP.
  final ForgotPasswordRepository repo;

  VerifyResetCode(this.repo);

  /// Executes the use case.
  /// Passes [email], [code], and [ownerProjectLinkId] to the repository.
  /// Returns [ForgotPasswordResult] on success; throws on failure.
  Future<ForgotPasswordResult> call({
    required String email,
    required String code,
    required int ownerProjectLinkId,
  }) {
    return repo.verifyResetCode(
      email: email,
      code: code,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}