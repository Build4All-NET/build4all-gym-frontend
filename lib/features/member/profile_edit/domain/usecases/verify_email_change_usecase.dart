import '../repositories/member_profile_edit_repository.dart';

class VerifyEmailChangeUseCase {
  final MemberProfileEditRepository _repository;

  VerifyEmailChangeUseCase(this._repository);

  Future<void> call({
    required String code,
  }) {
    return _repository.verifyEmailChange(code: code);
  }
}