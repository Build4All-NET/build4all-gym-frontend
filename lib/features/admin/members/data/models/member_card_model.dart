// =============================================================================
// FILE: member_card_model.dart
// LAYER: Data Layer → Models
//
// FIX: profileFileId is a Long in the backend (MemberCardDto.java) and
//      serializes as a JSON number, NOT a string. Changed storage to int?
//      and updated fromJson/toJson accordingly.
//      The entity keeps it as String? (for URL building) — conversion happens
//      in the repository's _toEntity() mapper.
//
// BACKEND DTO SHAPE (MemberCardDto.java):
//   userId           Long
//   fullName         String
//   memberCode       String
//   phone            String
//   profileFileId    Long        ← number, nullable
//   membershipStatus String      "active" | "expired" | "pending" | ...
//   planName         String
//   expiryDate       LocalDate   → serialized as "2025-08-01"
//   dueAmount        BigDecimal  → serialized as number
//   branchName       String
// =============================================================================

class MemberCardModel {
  final int userId;
  final String fullName;
  final String memberCode;
  final String phone;

  /// Nullable Long from the backend — null when no profile photo uploaded.
  /// Stored as int? here; converted to String? in the entity for URL building.
  final int? profileFileId;

  final String membershipStatus;
  final String planName;
  final String expiryDate;   // "2025-08-01" ISO-8601 date string
  final double dueAmount;
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

  factory MemberCardModel.fromJson(Map<String, dynamic> json) {
    return MemberCardModel(
      userId:           json['userId']           as int,
      fullName:         json['fullName']          as String? ?? '',
      memberCode:       json['memberCode']        as String? ?? '',
      phone:            json['phone']             as String? ?? '',

      // FIX: backend returns Long (number), not a String.
      // Cast safely — could be int or null.
      profileFileId:    json['profileFileId']     as int?,

      membershipStatus: json['membershipStatus']  as String? ?? 'inactive',
      planName:         json['planName']          as String? ?? '',
      expiryDate:       json['expiryDate']        as String? ?? '',
      dueAmount:        (json['dueAmount']        as num?)?.toDouble() ?? 0.0,
      branchName:       json['branchName']        as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId':           userId,
    'fullName':         fullName,
    'memberCode':       memberCode,
    'phone':            phone,
    'profileFileId':    profileFileId,
    'membershipStatus': membershipStatus,
    'planName':         planName,
    'expiryDate':       expiryDate,
    'dueAmount':        dueAmount,
    'branchName':       branchName,
  };
}