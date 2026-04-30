// =============================================================================
// FILE: member_card_entity.dart
// LAYER: Domain Layer → Entities
// PURPOSE: Pure Dart business object representing a single gym member.
//          The data layer maps MemberCardModel → MemberCardEntity.
//
// POSITION IN FLOW:
//   MemberCardModel (data layer)
//     → AdminMembersRepositoryImpl._toEntity()
//     → [this file] MemberCardEntity  ← BLoC stores List<MemberCardEntity>
//     → MemberCardWidget reads this to render the card UI
//
// RELATED FILES:
//   ← Mapped from: member_card_model.dart  (via repository impl)
//   → Used by:     admin_members_state.dart (MembersLoaded.members)
//   → Rendered by: member_card_widget.dart
// =============================================================================

class MemberCardEntity {
  final int userId;
  final String fullName;
  final String memberCode;
  final String phone;
  final String? profileFileId; // null → show initials avatar
  final String membershipStatus; // "active" | "pending" | "blocked" | "inactive"
  final String planName;
  final String expiryDate; // ISO-8601 string
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
  // Computed helpers used by the UI — keep presentation logic out of widgets.
  // ---------------------------------------------------------------------------

  /// Returns uppercase initials for the avatar circle, e.g. "Vikram Singh" → "VS".
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Returns true when the member has outstanding dues.
  bool get hasDues => dueAmount > 0;

  /// Convenience check so widgets don't hardcode the status string.
  bool get isBlocked => membershipStatus.toLowerCase() == 'blocked';
  bool get isActive => membershipStatus.toLowerCase() == 'active';
  bool get isPending => membershipStatus.toLowerCase() == 'pending';
}