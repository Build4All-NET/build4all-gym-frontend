// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/domain/repositories/forgot_password_repository.dart
//
// PURPOSE:
//   Abstract contract (interface) defining what data operations the domain
//   layer needs. The domain layer depends on this abstraction — NOT on the
//   concrete implementation. This is the "D" in SOLID (Dependency Inversion).
//
// WHY ABSTRACT:
//   - Makes the BLoC and use cases testable without a real network.
//   - Swapping the backend or mocking in tests requires changing only
//     ForgotPasswordRepositoryImpl, not the use cases or BLoC.
//
// RELATIONSHIPS:
//   ▶ Implemented by: ForgotPasswordRepositoryImpl (data layer)
//   ◀ Injected into:  SendResetCode, VerifyResetCode, UpdatePassword use cases
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/forgot_password_entity.dart';

abstract class ForgotPasswordRepository {
  /// Step 1: Sends an OTP reset code to [email].
  Future<ForgotPasswordResult> sendResetCode({
    required String email,
    required int ownerProjectLinkId,
  });

  /// Step 2: Verifies the OTP [code] the user entered.
  Future<ForgotPasswordResult> verifyResetCode({
    required String email,
    required String code,
    required int ownerProjectLinkId,
  });

  /// Step 3: Updates the password after OTP verification is complete.
  Future<ForgotPasswordResult> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  });
}