// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/data/repositories/forgot_password_repository_impl.dart
//
// PURPOSE:
//   Concrete implementation of ForgotPasswordRepository. This is the ONLY
//   class that knows about both the domain layer (entities) and the data layer
//   (API service, models). It acts as a translation bridge between them.
//
// WHAT IT DOES:
//   Calls the API service → receives ForgotMessageResponse (DTO) →
//   converts to ForgotPasswordResult (domain entity) →
//   returns to the use case.
//
//   Any exception thrown by the API service propagates upward — this class
//   does NOT catch errors (the BLoC handles that).
//
// RELATIONSHIPS:
//   ▶ Implements:  ForgotPasswordRepository
//   ▶ Uses:        ForgotPasswordApiService
//   ◀ Injected into: SendResetCode, VerifyResetCode, UpdatePassword use cases
//                    (via dependency injection at app startup)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:build4allgym/features/forgotpassword/domain/entities/forgot_password_entity.dart';
import 'package:build4allgym/features/forgotpassword/domain/repositories/forgot_password_repository.dart';
import '../services/forgot_password_api_service.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  /// The API service that handles raw HTTP calls. Injected for testability.
  final ForgotPasswordApiService api;

  ForgotPasswordRepositoryImpl({required this.api});

  /// Step 1: delegates to api.sendResetCode() and wraps the result in an entity.
  @override
  Future<ForgotPasswordResult> sendResetCode({
    required String email,
    required int ownerProjectLinkId,
  }) async {
    // Call the API → get the DTO
    final res = await api.sendResetCode(
      email: email,
      ownerProjectLinkId: ownerProjectLinkId,
    );
    // Convert DTO → domain entity (only the message crosses the boundary)
    return ForgotPasswordResult(message: res.message);
  }

  /// Step 2: delegates to api.verifyResetCode() and wraps the result.
  @override
  Future<ForgotPasswordResult> verifyResetCode({
    required String email,
    required String code,
    required int ownerProjectLinkId,
  }) async {
    final res = await api.verifyResetCode(
      email: email,
      code: code,
      ownerProjectLinkId: ownerProjectLinkId,
    );
    return ForgotPasswordResult(message: res.message);
  }

  /// Step 3: delegates to api.updatePassword() and wraps the result.
  @override
  Future<ForgotPasswordResult> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) async {
    final res = await api.updatePassword(
      email: email,
      code: code,
      newPassword: newPassword,
      ownerProjectLinkId: ownerProjectLinkId,
    );
    return ForgotPasswordResult(message: res.message);
  }
}