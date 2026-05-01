// =============================================================================
// FILE: member_detail_model.dart
// PATH: lib/features/admin/members/data/models/member_detail_model.dart
// LAYER: Data Layer → Models
// TASK: GA-267
// =============================================================================

import 'membership_package_model.dart';

class MemberDetailModel {
  final int     userId;
  final String? fullName;
  final String? phone;
  final int?    profileFileId;
  final String? membershipStatus;
  final String? trainingType;
  final String? gender;
  final MembershipPackageModel membershipPackage;

  const MemberDetailModel({
    required this.userId,
    this.fullName,
    this.phone,
    this.profileFileId,
    this.membershipStatus,
    this.trainingType,
    this.gender,
    required this.membershipPackage,
  });

  factory MemberDetailModel.fromJson(Map<String, dynamic> json) {
    return MemberDetailModel(
      userId:           json['userId']           as int,
      fullName:         json['fullName']          as String?,
      phone:            json['phone']             as String?,
      profileFileId:    json['profileFileId']     as int?,
      membershipStatus: json['membershipStatus']  as String?,
      trainingType:     json['trainingType']      as String?,
      gender:           json['gender']            as String?,
      membershipPackage: MembershipPackageModel.fromJson(
        json['membershipPackage'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId':            userId,
    'fullName':          fullName,
    'phone':             phone,
    'profileFileId':     profileFileId,
    'membershipStatus':  membershipStatus,
    'trainingType':      trainingType,
    'gender':            gender,
    'membershipPackage': membershipPackage.toJson(),
  };
}