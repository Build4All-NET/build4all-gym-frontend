import '../entities/member_build4all_profile_entity.dart';

abstract class MemberBuild4AllProfileRepository {
  Future<MemberBuild4AllProfileEntity> getMyProfile();
}