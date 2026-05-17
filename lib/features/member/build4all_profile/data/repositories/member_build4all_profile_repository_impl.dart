import 'package:build4allgym/features/member/build4all_profile/domain/entities/member_build4all_profile_entity.dart';
import 'package:build4allgym/features/member/build4all_profile/domain/repositories/member_build4all_profile_repository.dart';

import '../services/member_build4all_profile_service.dart';

class MemberBuild4AllProfileRepositoryImpl
    implements MemberBuild4AllProfileRepository {
  final MemberBuild4AllProfileService _service;

  MemberBuild4AllProfileRepositoryImpl(this._service);

  @override
  Future<MemberBuild4AllProfileEntity> getMyProfile() async {
    final model = await _service.getMyProfile();

    return MemberBuild4AllProfileEntity(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      username: model.username,
      email: model.email,
      phoneNumber: model.phoneNumber,
      profileImageUrl: model.profileImageUrl,
      publicProfile: model.publicProfile,
      status: model.status,
      pendingEmail: model.pendingEmail,
      emailVerificationRequired: model.emailVerificationRequired,
    );
  }
}