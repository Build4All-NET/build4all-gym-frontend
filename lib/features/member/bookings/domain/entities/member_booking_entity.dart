/*
 * Domain entity for the member "My Bookings" screen.
 *
 * This object represents one card in the screen.
 * It can be:
 * - CLASS booking from class_bookings
 * - PT session from pt_sessions
 *
 * Backend already sends one unified response shape.
 */
class MemberBookingEntity {
  final String bookingType;

  /*
   * CLASS:
   * - bookingId = class booking id
   *
   * PT:
   * - bookingId = pt session id
   */
  final int bookingId;

  /*
   * Only filled for CLASS bookings.
   */
  final int? sessionId;

  /*
   * Only filled for PT bookings.
   */
  final int? ptSessionId;

  /*
   * Real title from backend.
   *
   * CLASS:
   * - class name
   *
   * PT:
   * - package name if available
   * - can be null if backend has no package name
   */
  final String? title;

  final String? trainerName;

  final int? branchId;
  final String? branchName;

  /*
   * Usually exists for CLASS only.
   */
  final String? roomName;

  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  /*
   * Raw/computed backend status.
   *
   * Examples:
   * BOOKED
   * SCHEDULED
   * CANCEL_REQUESTED
   * ATTENDED
   * COMPLETED
   * NO_SHOW
   */
  final String status;

  /*
   * Translation key returned by backend.
   *
   * Frontend translates it from ARB.
   * No hardcoded Arabic/English in backend.
   */
  final String displayStatusKey;

  /*
   * Backend decides these flags.
   * UI only shows/hides buttons based on them.
   */
  final bool canRequestCancel;
  final bool cancelRequestPending;
  final bool canReview;

  /*
   * PT package fields.
   * Null for CLASS.
   */
  final String? packageName;
  final int? sessionIndex;
  final int? totalSessions;

  const MemberBookingEntity({
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

  bool get isClass => bookingType == 'CLASS';

  bool get isPt => bookingType == 'PT';

  /*
   * For PT cancel endpoint:
   * backend expects ptSessionId.
   * If backend response uses bookingId as same value, fallback keeps it safe.
   */
  int get effectivePtSessionId => ptSessionId ?? bookingId;
  MemberBookingEntity copyWith({
    String? bookingType,
    int? bookingId,
    int? sessionId,
    int? ptSessionId,
    String? title,
    String? trainerName,
    int? branchId,
    String? branchName,
    String? roomName,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? status,
    String? displayStatusKey,
    bool? canRequestCancel,
    bool? cancelRequestPending,
    bool? canReview,
    String? packageName,
    int? sessionIndex,
    int? totalSessions,
  }) {
    return MemberBookingEntity(
      bookingType: bookingType ?? this.bookingType,
      bookingId: bookingId ?? this.bookingId,
      sessionId: sessionId ?? this.sessionId,
      ptSessionId: ptSessionId ?? this.ptSessionId,
      title: title ?? this.title,
      trainerName: trainerName ?? this.trainerName,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      roomName: roomName ?? this.roomName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      displayStatusKey: displayStatusKey ?? this.displayStatusKey,
      canRequestCancel: canRequestCancel ?? this.canRequestCancel,
      cancelRequestPending: cancelRequestPending ?? this.cancelRequestPending,
      canReview: canReview ?? this.canReview,
      packageName: packageName ?? this.packageName,
      sessionIndex: sessionIndex ?? this.sessionIndex,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }
}