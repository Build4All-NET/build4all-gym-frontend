// =============================================================================
// FILE: member_card_entity.dart
// LAYER: Domain Layer → Entities
//
// CHANGE: Added copyWith() so the BLoC can patch status/dueAmount
//         client-side after block/unblock without re-fetching from the API.
// =============================================================================

class MemberCardEntity {
  final int userId;
  final String fullName;
  final String memberCode;
  final String phone;
  final int? profileFileId;
  final String membershipStatus; // "active" | "pending" | "blocked" | "inactive"
  final String planName;
  final String expiryDate;
  final double dueAmount;
  final String branchName;

  const MemberCardEntity({
    required this.userId,
    required this.fullName,
    required this.memberCode,
    required this.phone,
    this.profileFileId,
    required this.membershipStatus,
    required this.planName,
    required this.expiryDate,
    required this.dueAmount,
    required this.branchName,
  });

  // ---------------------------------------------------------------------------
  // copyWith — used by the BLoC to patch individual fields in-place.
  // Example: m.copyWith(membershipStatus: 'blocked')
  // ---------------------------------------------------------------------------
  MemberCardEntity copyWith({
    String? membershipStatus,
    String? planName,
    String? expiryDate,
    double? dueAmount,
    int? profileFileId,
  }) {
    return MemberCardEntity(
      userId: userId,
      fullName: fullName,
      memberCode: memberCode,
      phone: phone,
      profileFileId: profileFileId ?? this.profileFileId,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      planName: planName ?? this.planName,
      expiryDate: expiryDate ?? this.expiryDate,
      dueAmount: dueAmount ?? this.dueAmount,
      branchName: branchName,
    );
  }

  // ---------------------------------------------------------------------------
  // Computed helpers used by the UI.
  // ---------------------------------------------------------------------------

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  bool get hasDues    => dueAmount > 0;
  bool get isBlocked  => membershipStatus.toLowerCase() == 'blocked';
  bool get isActive   => membershipStatus.toLowerCase() == 'active';
  bool get isPending  => membershipStatus.toLowerCase() == 'pending';
}