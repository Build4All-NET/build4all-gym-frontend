import 'member_account_stats_entity.dart';

class MemberAccountEntity {
  final int userId;

  // Gym-owned member profile data
  final String? dateOfBirth;
  final String? address;
  final String? gender;

  // Gym membership data
  final String? memberSince;
  final String? planName;
  final String? referralCode;

  // Gym activity counters
  final int activeBookingsCount;
  final MemberAccountStatsEntity stats;

  const MemberAccountEntity({
    required this.userId,
    this.dateOfBirth,
    this.address,
    this.gender,
    this.memberSince,
    this.planName,
    this.referralCode,
    required this.activeBookingsCount,
    required this.stats,
  });
}