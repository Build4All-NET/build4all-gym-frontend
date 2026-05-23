import '../repositories/member_profile_edit_repository.dart';

class VerifyProfilePhoneCodeUseCase {
  final MemberProfileEditRepository repository;

  const VerifyProfilePhoneCodeUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required String code,
  }) {
    return repository.verifyPhoneChangeCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}