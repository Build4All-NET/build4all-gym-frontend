import 'package:equatable/equatable.dart';

import '../../domain/entities/visit_record.dart';

/// Base class for all member QR states.
///
/// The UI listens to this state and decides what to show:
/// - initial
/// - loading
/// - loaded QR screen
/// - error
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
///
/// Used when the screen opens and QR data is being loaded.
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
  /// Secure UUID token.
  ///
  /// Later, the QR widget will use this:
  /// QrImageView(data: token)
  final String token;

  /// Token expiration timestamp.
  ///
  /// Used by the BLoC timer to auto-refresh the QR.
  final DateTime expiresAt;

  /// Membership status.
  ///
  /// Examples:
  /// ACTIVE
  /// EXPIRED
  /// CANCELLED
  /// FROZEN
  /// PENDING
  /// NO_MEMBERSHIP
  final String membershipStatus;

  /// Member full name from backend.
  ///
  /// Comes from users.full_name.
  final String memberName;

  /// Member code.
  ///
  /// Example:
  /// GYM-2024-1234
  final String memberCode;

  /// Package name.
  ///
  /// Example:
  /// الباقة الذهبية
  final String packageName;

  /// Membership valid-until date.
  ///
  /// Example:
  /// 2026-07-15
  final String validUntil;

  /// Last 10 visits.
  final List<VisitRecord> recentVisits;

  const MemberQrLoaded({
    required this.token,
    required this.expiresAt,
    required this.membershipStatus,
    required this.memberName,
    required this.memberCode,
    required this.packageName,
    required this.validUntil,
    required this.recentVisits,
  });

  /// True when QR token expires in less than 60 seconds.
  ///
  /// Later, the UI uses this to show a small warning/countdown.
  bool get isExpiringSoon {
    final remainingSeconds = expiresAt.difference(DateTime.now()).inSeconds;
    return remainingSeconds <= 60 && remainingSeconds > 0;
  }

  /// Remaining seconds before token expiration.
  ///
  /// Example:
  /// 45 means the token expires in 45 seconds.
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
    recentVisits,
  ];
}

/// Error state.
///
/// Used if loading or refreshing fails.
class MemberQrError extends MemberQrState {
  final String message;

  const MemberQrError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}