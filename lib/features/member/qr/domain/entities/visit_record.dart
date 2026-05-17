import 'package:equatable/equatable.dart';

/// Domain entity for one recent gym visit.
///
/// This is not an API model.
/// This is the clean object used by:
/// - MemberQrData
/// - MemberQrLoaded state
/// - Recent visits UI later
///
/// Example:
/// VisitRecord(
///   checkinTime: DateTime.parse('2026-05-15T18:00:00'),
///   checkoutTime: DateTime.parse('2026-05-15T20:00:00'),
///   durationMinutes: 120,
/// )
class VisitRecord extends Equatable {
  /// When the member checked in.
  final DateTime checkinTime;

  /// When the member checked out.
  ///
  /// Null means:
  /// - checkout was not recorded
  /// - or member is still inside
  final DateTime? checkoutTime;

  /// Visit duration in minutes.
  ///
  /// Example:
  /// 120 = 2 hours.
  ///
  /// Null if checkoutTime is null.
  final int? durationMinutes;

  const VisitRecord({
    required this.checkinTime,
    this.checkoutTime,
    this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    checkinTime,
    checkoutTime,
    durationMinutes,
  ];
}