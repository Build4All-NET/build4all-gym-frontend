import '../repositories/member_profile_edit_repository.dart';

class VerifyCurrentPasswordUseCase {
  final MemberProfileEditRepository _repository;

  VerifyCurrentPasswordUseCase(this._repository);

  Future<void> call({
    required String email,
    required String currentPassword,
    required int ownerProjectLinkId,
  }) {
    return _repository.verifyCurrentPassword(
      email: email,
      currentPassword: currentPassword,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}