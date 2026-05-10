import 'member_account_stats_model.dart';

class MemberAccountModel {
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
  final MemberAccountStatsModel stats;

  const MemberAccountModel({
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

  factory MemberAccountModel.fromJson(Map<String, dynamic> json) {
    return MemberAccountModel(
      userId: json['userId'] as int,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      memberSince: json['memberSince'] as String?,
      planName: json['planName'] as String?,
      referralCode: json['referralCode'] as String?,
      activeBookingsCount: json['activeBookingsCount'] as int? ?? 0,
      stats: MemberAccountStatsModel.fromJson(
        (json['stats'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'gender': gender,
      'memberSince': memberSince,
      'planName': planName,
      'referralCode': referralCode,
      'activeBookingsCount': activeBookingsCount,
      'stats': stats.toJson(),
    };
  }
}