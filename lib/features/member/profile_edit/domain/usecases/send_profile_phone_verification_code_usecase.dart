import 'package:build4allgym/features/member/profile_edit/domain/repositories/member_profile_edit_repository.dart';

class SendProfilePhoneVerificationCodeUseCase {
  final MemberProfileEditRepository repository;

  const SendProfilePhoneVerificationCodeUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required int ownerProjectLinkId,
  }) {
    return repository.sendPhoneChangeVerificationCode(
      phoneNumber: phoneNumber,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}