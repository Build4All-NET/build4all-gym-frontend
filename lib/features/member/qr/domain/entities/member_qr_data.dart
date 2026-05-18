import 'package:equatable/equatable.dart';

import 'visit_record.dart';

/// Domain entity for the full member QR screen data.
///
/// This matches what backend returns from:
/// GET /api/member/qr
///
/// Display priority is decided by backend:
/// 1. SESSION
/// 2. MEMBERSHIP
/// 3. NONE
class MemberQrData extends Equatable {
  /// Secure UUID token used by the QR widget.
  final String token;

  /// QR token expiration date/time.
  final DateTime expiresAt;

  /// Backend status.
  ///
  /// Examples:
  /// SESSION, ACTIVE, EXPIRED, CANCELLED, FROZEN,
  /// PENDING, NO_MEMBERSHIP, NO_ACTIVE_ACCESS
  final String membershipStatus;

  /// Member full name from backend.
  final String memberName;

  /// Member code.
  final String memberCode;

  /// Old compatible field.
  ///
  /// If accessType = SESSION:
  /// - session/class name
  ///
  /// If accessType = MEMBERSHIP:
  /// - membership package name
  final String packageName;

  /// Old compatible field.
  ///
  /// If accessType = SESSION:
  /// - session date
  ///
  /// If accessType = MEMBERSHIP:
  /// - membership end date
  final String validUntil;

  /// New clean frontend display type.
  ///
  /// Values:
  /// SESSION, MEMBERSHIP, NONE
  final String accessType;

  /// Main title for card.
  ///
  /// Examples:
  /// Boxing, Gold Package, No active access
  final String accessTitle;

  /// Subtitle for card.
  ///
  /// Examples:
  /// Session with Ahmad, Active membership
  final String accessSubtitle;

  /// Branch name for session.
  ///
  /// Null/empty for membership.
  final String accessBranchName;

  /// Session start time.
  ///
  /// Null for membership or no access.
  final DateTime? accessStartTime;

  /// Session end time.
  ///
  /// Null for membership or no access.
  final DateTime? accessEndTime;

  /// Last 10 visit records.
  final List<VisitRecord> recentVisits;

  /// Plan's allowed entry window start "HH:mm" — null if no restriction.
  final String? planGymAccessStart;

  /// Plan's allowed entry window end "HH:mm" — null if no restriction.
  final String? planGymAccessEnd;

  const MemberQrData({
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
    this.planGymAccessStart,
    this.planGymAccessEnd,
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
    accessType,
    accessTitle,
    accessSubtitle,
    accessBranchName,
    accessStartTime,
    accessEndTime,
    recentVisits,
    planGymAccessStart,
    planGymAccessEnd,
  ];
}