import '../repositories/member_profile_edit_repository.dart';

class ResendEmailChangeCodeUseCase {
  final MemberProfileEditRepository _repository;

  ResendEmailChangeCodeUseCase(this._repository);

  Future<void> call() {
    return _repository.resendEmailChangeCode();
  }
}