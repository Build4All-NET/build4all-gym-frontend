import '../../domain/entities/member_qr_data.dart';
import '../../domain/entities/visit_record.dart';

/// API model for one visit item from backend.
///
/// Backend JSON example:
/// {
///   "checkinTime": "2026-05-15T18:00:00",
///   "checkoutTime": "2026-05-15T20:00:00",
///   "durationMinutes": 120
/// }
class VisitRecordModel {
  final DateTime checkinTime;
  final DateTime? checkoutTime;
  final int? durationMinutes;

  const VisitRecordModel({
    required this.checkinTime,
    this.checkoutTime,
    this.durationMinutes,
  });

  /// Converts backend JSON into VisitRecordModel.
  factory VisitRecordModel.fromJson(Map<String, dynamic> json) {
    return VisitRecordModel(
      checkinTime: DateTime.parse(json['checkinTime'] as String),
      checkoutTime: json['checkoutTime'] == null
          ? null
          : DateTime.parse(json['checkoutTime'] as String),
      durationMinutes: json['durationMinutes'] as int?,
    );
  }

  /// Converts data model into clean domain entity.
  VisitRecord toEntity() {
    return VisitRecord(
      checkinTime: checkinTime,
      checkoutTime: checkoutTime,
      durationMinutes: durationMinutes,
    );
  }
}

/// API model for:
/// GET /api/member/qr
///
/// This model parses JSON only.
/// The BLoC should use MemberQrData, not this model directly.
class MemberQrModel {
  final String token;
  final DateTime expiresAt;
  final String membershipStatus;

  /// Member full name from backend.
  final String memberName;

  final String memberCode;

  /// Old compatible field.
  ///
  /// If accessType = SESSION:
  /// - session/class name
  ///
  /// If accessType = MEMBERSHIP:
  /// - membership plan name
  final String packageName;

  /// Old compatible field.
  ///
  /// If accessType = SESSION:
  /// - session date
  ///
  /// If accessType = MEMBERSHIP:
  /// - membership end date
  final String validUntil;

  /// New backend field.
  ///
  /// Possible values:
  /// SESSION, MEMBERSHIP, NONE
  final String accessType;

  /// Main title shown in the QR card.
  ///
  /// Examples:
  /// Boxing, Gold Package, No active access
  final String accessTitle;

  /// Subtitle shown under title.
  ///
  /// Examples:
  /// Session with Ahmad, Active membership
  final String accessSubtitle;

  /// Branch name for session.
  ///
  /// Empty for membership/no access.
  final String accessBranchName;

  /// Session start time.
  ///
  /// Null for membership/no access.
  final DateTime? accessStartTime;

  /// Session end time.
  ///
  /// Null for membership/no access.
  final DateTime? accessEndTime;

  final List<VisitRecordModel> recentVisits;

  const MemberQrModel({
    required this.token,
    required this.expiresAt,
    required this.membershipStatus,
    required this.memberName,
    required this.memberCode,
    required this.packageName,
    required this.validUntil,
    required this.accessType,
    required this.accessTitle,
    required this.accessSubtitle,
    required this.accessBranchName,
    required this.accessStartTime,
    required this.accessEndTime,
    required this.recentVisits,
  });

  /// Converts backend JSON into MemberQrModel.
  factory MemberQrModel.fromJson(Map<String, dynamic> json) {
    final visitsJson = json['recentVisits'];

    return MemberQrModel(
      token: (json['token'] as String?) ?? '',
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      membershipStatus: (json['membershipStatus'] as String?) ?? 'NO_MEMBERSHIP',
      memberName: (json['memberName'] as String?) ?? '',
      memberCode: (json['memberCode'] as String?) ?? '',
      packageName: (json['packageName'] as String?) ?? '',
      validUntil: (json['validUntil'] as String?) ?? '',

      /// New fields from backend.
      accessType: (json['accessType'] as String?) ?? 'NONE',
      accessTitle: (json['accessTitle'] as String?) ?? '',
      accessSubtitle: (json['accessSubtitle'] as String?) ?? '',
      accessBranchName: (json['accessBranchName'] as String?) ?? '',

      accessStartTime: json['accessStartTime'] == null
          ? null
          : DateTime.parse(json['accessStartTime'] as String),

      accessEndTime: json['accessEndTime'] == null
          ? null
          : DateTime.parse(json['accessEndTime'] as String),

      recentVisits: visitsJson is List
          ? visitsJson
          .whereType<Map<String, dynamic>>()
          .map(VisitRecordModel.fromJson)
          .toList()
          : const [],
    );
  }

  /// Converts API model into clean domain entity.
  MemberQrData toEntity() {
    return MemberQrData(
      token: token,
      expiresAt: expiresAt,
      membershipStatus: membershipStatus,
      memberName: memberName,
      memberCode: memberCode,
      packageName: packageName,
      validUntil: validUntil,
      accessType: accessType,
      accessTitle: accessTitle,
      accessSubtitle: accessSubtitle,
      accessBranchName: accessBranchName,
      accessStartTime: accessStartTime,
      accessEndTime: accessEndTime,
      recentVisits: recentVisits.map((visit) => visit.toEntity()).toList(),
    );
  }
}