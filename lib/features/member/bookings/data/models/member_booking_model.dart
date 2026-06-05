/*
 * Data model for /api/member/bookings response.
 *
 * This class only parses JSON.
 * Mapping to domain entity happens in repository implementation.
 */
class MemberBookingModel {
  final String bookingType;
  final int bookingId;
  final int? sessionId;
  final int? ptSessionId;
  final String? title;
  final String? trainerName;
  final int? branchId;
  final String? branchName;
  final String? roomName;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String status;
  final String displayStatusKey;
  final bool canRequestCancel;
  final bool cancelRequestPending;
  final bool canReview;
  final String? packageName;
  final int? sessionIndex;
  final int? totalSessions;

  const MemberBookingModel({
    required this.bookingType,
    required this.bookingId,
    this.sessionId,
    this.ptSessionId,
    this.title,
    this.trainerName,
    this.branchId,
    this.branchName,
    this.roomName,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.status,
    required this.displayStatusKey,
    required this.canRequestCancel,
    required this.cancelRequestPending,
    required this.canReview,
    this.packageName,
    this.sessionIndex,
    this.totalSessions,
  });

  factory MemberBookingModel.fromJson(Map<String, dynamic> json) {
    return MemberBookingModel(
      bookingType: json['bookingType'] as String,
      bookingId: _toInt(json['bookingId'])!,
      sessionId: _toInt(json['sessionId']),
      ptSessionId: _toInt(json['ptSessionId']),
      title: json['title'] as String?,
      trainerName: json['trainerName'] as String?,
      branchId: _toInt(json['branchId']),
      branchName: json['branchName'] as String?,
      roomName: json['roomName'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: _toInt(json['durationMinutes']) ?? 0,
      status: json['status'] as String,
      displayStatusKey: json['displayStatusKey'] as String? ?? 'bookingStatusUnknown',
      canRequestCancel: json['canRequestCancel'] as bool? ?? false,
      cancelRequestPending: json['cancelRequestPending'] as bool? ?? false,
      canReview: json['canReview'] as bool? ?? false,
      packageName: json['packageName'] as String?,
      sessionIndex: _toInt(json['sessionIndex']),
      totalSessions: _toInt(json['totalSessions']),
    );
  }

  /*
   * Backend may return Integer as int, or sometimes JSON decoder sees it as num.
   * This keeps parsing stable.
   */
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}