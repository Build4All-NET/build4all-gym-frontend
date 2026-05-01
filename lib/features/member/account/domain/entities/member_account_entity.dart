import 'member_account_stats_entity.dart';

class MemberAccountEntity {
  final int userId;
  final String fullName;
  final String? memberSince;
  final String? planName;
  final int? profileFileId;
  final String? email;
  final String? phone;
  final String? dateOfBirth;
  final String? address;
  final String? referralCode;
  final int activeBookingsCount;
  final MemberAccountStatsEntity stats;

  const MemberAccountEntity({
    required this.userId,
    required this.fullName,
    this.memberSince,
    this.planName,
    this.profileFileId,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.address,
    this.referralCode,
    required this.activeBookingsCount,
    required this.stats,
  });
}