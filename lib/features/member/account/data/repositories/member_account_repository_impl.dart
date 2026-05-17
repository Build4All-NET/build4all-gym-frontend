import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_stats_entity.dart';
import 'package:build4allgym/features/member/account/domain/repositories/member_account_repository.dart';

import '../models/update_profile_request_model.dart';
import '../services/member_account_service.dart';

class MemberAccountRepositoryImpl implements MemberAccountRepository {
  final MemberAccountService _service;

  MemberAccountRepositoryImpl(this._service);

  @override
  Future<MemberAccountEntity> getMemberAccount() async {
    try {
      final model = await _service.getMemberAccount();

      return MemberAccountEntity(
        userId: model.userId,
        dateOfBirth: model.dateOfBirth,
        address: model.address,
        gender: model.gender,
        memberSince: model.memberSince,
        planName: model.planName,
        referralCode: model.referralCode,
        activeBookingsCount: model.activeBookingsCount,
        stats: MemberAccountStatsEntity(
          sessionsCount: model.stats.sessionsCount,
          exercisesCount: model.stats.exercisesCount,
        ),
      );
    } catch (e) {
      throw Exception('Failed to load account');
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileRequestModel request) async {
    try {
      await _service.updateProfile(request);
    } catch (e) {
      throw Exception('Failed to update profile');
    }
  }
}