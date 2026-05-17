import '../repositories/member_profile_edit_repository.dart';

class UpdateBuild4AllProfileUseCase {
  final MemberProfileEditRepository _repository;

  UpdateBuild4AllProfileUseCase(this._repository);

  Future<void> call({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) {
    return _repository.updateBuild4AllProfile(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}