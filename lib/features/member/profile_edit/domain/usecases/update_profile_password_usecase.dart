import '../repositories/member_profile_edit_repository.dart';

class UpdateProfilePasswordUseCase {
  final MemberProfileEditRepository _repository;

  UpdateProfilePasswordUseCase(this._repository);

  Future<void> call({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) {
    return _repository.updatePassword(
      email: email,
      code: code,
      newPassword: newPassword,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}