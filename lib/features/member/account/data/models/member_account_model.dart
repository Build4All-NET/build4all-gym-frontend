import 'member_account_stats_model.dart';

class MemberAccountModel {
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
  final MemberAccountStatsModel stats;

  const MemberAccountModel({
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

  factory MemberAccountModel.fromJson(Map<String, dynamic> json) {
    return MemberAccountModel(
      userId: json['userId'] as int,
      fullName: json['fullName'] as String,
      memberSince: json['memberSince'] as String?,
      planName: json['planName'] as String?,
      profileFileId: json['profileFileId'] as int?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      referralCode: json['referralCode'] as String?,
      activeBookingsCount: json['activeBookingsCount'] as int,
      stats: MemberAccountStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'memberSince': memberSince,
      'planName': planName,
      'profileFileId': profileFileId,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'referralCode': referralCode,
      'activeBookingsCount': activeBookingsCount,
      'stats': stats.toJson(),
    };
  }
}