import 'package:equatable/equatable.dart';

import 'visit_record.dart';

/// Domain entity for the full member QR screen data.
///
/// This matches what our backend returns from:
/// GET /api/member/qr
///
/// Backend response example:
/// {
///   "token": "550e8400-e29b-41d4-a716-446655440000",
///   "expiresAt": "2026-05-15T12:35:00",
///   "membershipStatus": "ACTIVE",
///   "memberName": "Ahmad Ali",
///   "memberCode": "GYM-2024-1234",
///   "packageName": "الباقة الذهبية",
///   "validUntil": "2026-07-15",
///   "recentVisits": []
/// }
class MemberQrData extends Equatable {
  /// Secure UUID token used by the QR widget.
  final String token;

  /// QR token expiration date/time.
  final DateTime expiresAt;

  /// Membership status from backend.
  ///
  /// Examples:
  /// ACTIVE, EXPIRED, CANCELLED, FROZEN, PENDING, NO_MEMBERSHIP
  final String membershipStatus;

  /// Member full name from backend.
  ///
  /// Comes from users.full_name.
  final String memberName;

  /// Member code from backend.
  ///
  /// Example:
  /// GYM-2024-1234
  final String memberCode;

  /// Membership package name from membership_plans.name.
  final String packageName;

  /// Membership end date.
  ///
  /// Kept as String because backend sends a date-only value:
  /// 2026-07-15
  final String validUntil;

  /// Last 10 visit records.
  final List<VisitRecord> recentVisits;

  const MemberQrData({
    required this.token,
    required this.expiresAt,
    required this.membershipStatus,
    required this.memberName,
    required this.memberCode,
    required this.packageName,
    required this.validUntil,
    required this.recentVisits,
  });

  @override
  List<Object?> get props => [
    token,
    expiresAt,
    membershipStatus,
    memberName,
    memberCode,
    packageName,
    validUntil,
    recentVisits,
  ];
}