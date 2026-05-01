import '../entities/member_account_entity.dart';
import '../../data/models/update_profile_request_model.dart';

abstract class MemberAccountRepository {
  Future<MemberAccountEntity> getMemberAccount();
  Future<void> updateProfile(UpdateProfileRequestModel request);
}