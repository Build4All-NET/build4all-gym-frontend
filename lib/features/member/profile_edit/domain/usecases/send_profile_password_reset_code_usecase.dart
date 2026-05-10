import '../repositories/member_profile_edit_repository.dart';

class SendProfilePasswordResetCodeUseCase {
  final MemberProfileEditRepository _repository;

  SendProfilePasswordResetCodeUseCase(this._repository);

  Future<void> call({
    required String email,
    required int ownerProjectLinkId,
  }) {
    return _repository.sendPasswordResetCode(
      email: email,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }
}