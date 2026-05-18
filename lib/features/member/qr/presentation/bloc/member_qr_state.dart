import 'package:equatable/equatable.dart';

import '../../domain/entities/visit_record.dart';

/// Base class for all member QR states.
abstract class MemberQrState extends Equatable {
  const MemberQrState();

  @override
  List<Object?> get props => [];
}

/// Initial state before anything is loaded.
class MemberQrInitial extends MemberQrState {
  const MemberQrInitial();
}

/// Loading state.
class MemberQrLoading extends MemberQrState {
  const MemberQrLoading();
}

/// Loaded state.
///
/// This contains everything needed by the member QR screen.
///
/// Data comes from:
/// GET /api/member/qr
class MemberQrLoaded extends MemberQrState {
  /// Secure UUID token used by QrImageView(data: token).
  final String token;

  /// Token expiration timestamp.
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

  /// New clean display type.
  ///
  /// Values:
  /// SESSION, MEMBERSHIP, NONE
  final String accessType;

  /// Main title shown in the card.
  ///
  /// Examples:
  /// Boxing, Gold Package, No active access
  final String accessTitle;

  /// Subtitle under the title.
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

  /// Last 10 visits.
  final List<VisitRecord> recentVisits;

  /// Plan's allowed entry window start "HH:mm" — null if no restriction.
  final String? planGymAccessStart;

  /// Plan's allowed entry window end "HH:mm" — null if no restriction.
  final String? planGymAccessEnd;

  const MemberQrLoaded({
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

  /// True when QR token expires in less than 60 seconds.
  bool get isExpiringSoon {
    final remainingSeconds = expiresAt.difference(DateTime.now()).inSeconds;
    return remainingSeconds <= 60 && remainingSeconds > 0;
  }

  /// Remaining seconds before token expiration.
  int get remainingSeconds {
    final seconds = expiresAt.difference(DateTime.now()).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

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

/// Error state.
class MemberQrError extends MemberQrState {
  final String message;

  const MemberQrError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}