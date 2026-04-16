// ─────────────────────────────────────────────────────────────────────────────
//
// PURPOSE:
//   Use case for Step 3 of the forgot-password flow.
//   One job: send the verified code + new password to the backend to update it.
//
// RELATIONSHIPS:
//   ▶ Depends on:  ForgotPasswordRepository (injected, abstract)
//   ◀ Called by:   ForgotPasswordBloc._onUpdate()
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/forgot_password_entity.dart';
import '../repositories/forgot_password_repository.dart';

class UpdatePassword {
  /// Abstract repository — injected so this use case is testable without HTTP.
  final ForgotPasswordRepository repo;

  UpdatePassword(this.repo);

  /// Executes the use case.
  /// Passes [email], [code], [newPassword], and [ownerProjectLinkId] to
  /// the repository. Returns [ForgotPasswordResult] on success; throws on failure.
  Future<ForgotPasswordResult> call({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) {
    return repo.updatePassword(
      email: email,
      code: code,
      newPassword: newPassword,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}