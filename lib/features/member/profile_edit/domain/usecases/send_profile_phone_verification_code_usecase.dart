import '../repositories/member_profile_edit_repository.dart';

class SendProfilePhoneVerificationCodeUseCase {
  final MemberProfileEditRepository repository;

  const SendProfilePhoneVerificationCodeUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required String password,
    required int ownerProjectLinkId,
  }) {
    return repository.sendPhoneChangeVerificationCode(
      phoneNumber: phoneNumber,
      password: password,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}