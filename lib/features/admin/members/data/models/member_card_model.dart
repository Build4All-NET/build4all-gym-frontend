// =============================================================================
// FILE: member_card_model.dart
// LAYER: Data Layer → Models
// PURPOSE: Raw API response model for a single gym member.
//          Handles JSON parsing/serialization from the backend.
//          Does NOT contain business logic — that belongs in the domain layer.
//
// POSITION IN FLOW:
//   API Response (JSON)
//     → [this file] MemberCardModel.fromJson()
//     → AdminMembersRepositoryImpl maps it to MemberCardEntity
//     → Domain / BLoC / UI use MemberCardEntity
//
// RELATED FILES:
//   ← Consumed by: admin_members_repository_impl.dart (maps to entity)
//   ← Consumed by: member_list_response_model.dart (builds list of these)
//   → Maps to:     member_card_entity.dart (pure domain class)
// =============================================================================

class MemberCardModel {
  /// Unique backend ID for this user/member record.
  final int userId;

  /// Full display name, e.g. "Vikram Singh".
  final String fullName;

  /// Human-readable member code, e.g. "MEM005".
  final String memberCode;

  /// Phone number string, e.g. "+91 98765 43215".
  final String phone;

  /// Optional file/avatar ID if the member has uploaded a profile photo.
  /// Null means we show initials avatar instead.
  final String? profileFileId;

  /// Membership status: "active" | "pending" | "blocked" | "inactive".
  final String membershipStatus;

  /// Name of the plan the member is enrolled in, e.g. "HIIT Quarterly".
  final String planName;

  /// ISO-8601 date string for when the plan expires, e.g. "2026-06-01".
  final String expiryDate;

  /// Outstanding due amount in rupees. 0 means no dues.
  final double dueAmount;

  /// Branch name the member belongs to, e.g. "Mumbai Central".
  final String branchName;

  const MemberCardModel({
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
  // fromJson — converts a Map (parsed JSON) → MemberCardModel instance.
  // Called by MemberListResponseModel when it iterates the "items" list.
  // ---------------------------------------------------------------------------
  factory MemberCardModel.fromJson(Map<String, dynamic> json) {
    return MemberCardModel(
      // Backend may return int or String for userId — always cast safely.
      userId: json['userId'] as int,
      fullName: json['fullName'] as String? ?? '',
      memberCode: json['memberCode'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profileFileId: json['profileFileId'] as String?,
      membershipStatus: json['membershipStatus'] as String? ?? 'inactive',
      planName: json['planName'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      // dueAmount can come as int or double from JSON.
      dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
      branchName: json['branchName'] as String? ?? '',
    );
  }

  // ---------------------------------------------------------------------------
  // toJson — converts MemberCardModel → Map, useful for caching or debug logs.
  // ---------------------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'memberCode': memberCode,
      'phone': phone,
      'profileFileId': profileFileId,
      'membershipStatus': membershipStatus,
      'planName': planName,
      'expiryDate': expiryDate,
      'dueAmount': dueAmount,
      'branchName': branchName,
    };
  }
}