// =============================================================================
// FILE: member_detail_entity.dart
// PATH: lib/features/admin/members/domain/entities/member_detail_entity.dart
// LAYER: Domain Layer → Entities
// TASK: GA-269
// =============================================================================

import 'membership_package_entity.dart';

class MemberDetailEntity {
  final int     userId;
  final String? fullName;
  final String? phone;
  final String? profileFileId;
  final String? membershipStatus;
  final String? trainingType;
  final String? gender;
  final MembershipPackageEntity membershipPackage;

  const MemberDetailEntity({
    required this.userId,
    this.fullName,
    this.phone,
    this.profileFileId,
    this.membershipStatus,
    this.trainingType,
    this.gender,
    required this.membershipPackage,
  });

  String get initials {
    final name = fullName?.trim() ?? '';
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  bool get isBlocked  => membershipStatus?.toLowerCase() == 'blocked';
  bool get isActive   => membershipStatus?.toLowerCase() == 'active';
  bool get isInactive => membershipStatus?.toLowerCase() == 'inactive';
}