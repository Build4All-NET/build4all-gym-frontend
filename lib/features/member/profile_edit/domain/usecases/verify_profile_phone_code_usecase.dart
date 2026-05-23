import 'package:build4allgym/features/member/profile_edit/domain/repositories/member_profile_edit_repository.dart';

/// Verifies the OTP code sent to the new phone number during Edit Profile.
///
/// Uses the same Build4All API style as ecommerce:
///
/// POST /api/auth/user/verify-phone-code
///
/// Body:
/// {
///   "phoneNumber": "+961...",
///   "code": "123456"
/// }
///
/// This usecase only verifies the phone.
/// After success, the UI should submit the profile again with:
///
/// phoneAlreadyVerified: true
class VerifyProfilePhoneCodeUseCase {
  final MemberProfileEditRepository repository;

  const VerifyProfilePhoneCodeUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required String code,
  }) async {
    await repository.verifyPhoneChangeCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}