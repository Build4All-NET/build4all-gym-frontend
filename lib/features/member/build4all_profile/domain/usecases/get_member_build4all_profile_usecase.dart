import '../entities/member_build4all_profile_entity.dart';
import '../repositories/member_build4all_profile_repository.dart';

class GetMemberBuild4AllProfileUseCase {
  final MemberBuild4AllProfileRepository _repository;

  GetMemberBuild4AllProfileUseCase(this._repository);

  Future<MemberBuild4AllProfileEntity> call() {
    return _repository.getMyProfile();
  }
}