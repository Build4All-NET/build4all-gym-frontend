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
///
/// This model belongs to the data layer because it knows JSON.
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
/// Backend JSON example:
/// {
///   "token": "uuid-string",
///   "expiresAt": "2026-05-15T12:35:00",
///   "membershipStatus": "ACTIVE",
///   "memberName": "Ahmad Ali",
///   "memberCode": "GYM-2024-1234",
///   "packageName": "الباقة الذهبية",
///   "validUntil": "2026-07-15",
///   "recentVisits": []
/// }
///
/// Important:
/// This file parses API JSON only.
/// The BLoC should not depend directly on this model.
class MemberQrModel {
  final String token;
  final DateTime expiresAt;
  final String membershipStatus;

  /// Member full name from backend.
  ///
  /// Comes from:
  /// users.full_name
  final String memberName;

  final String memberCode;
  final String packageName;
  final String validUntil;
  final List<VisitRecordModel> recentVisits;

  const MemberQrModel({
    required this.token,
    required this.expiresAt,
    required this.membershipStatus,
    required this.memberName,
    required this.memberCode,
    required this.packageName,
    required this.validUntil,
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
      recentVisits: recentVisits.map((visit) => visit.toEntity()).toList(),
    );
  }
}