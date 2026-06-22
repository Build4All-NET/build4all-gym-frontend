/// One row in the Employee Check-Ins screen — every active employee at the
/// branch, merged with today's check-in status (if any).
class EmployeeCheckinRowEntity {
  final int employeeId;
  final String employeeName;
  final String employeeType;

  /// True when this employee has an app account (trainer/reception) and
  /// self-scans rather than being manually checked in/out.
  final bool isLinked;

  final int? employeeCheckinId;
  /// One of: NOT_CHECKED_IN, ACTIVE, CHECKED_OUT.
  final String status;
  /// One of: SCAN, MANUAL — null when status is NOT_CHECKED_IN.
  final String? method;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;

  bool get isCheckedIn => status == 'ACTIVE';

  const EmployeeCheckinRowEntity({
    required this.employeeId,
    required this.employeeName,
    required this.employeeType,
    required this.isLinked,
    this.employeeCheckinId,
    required this.status,
    this.method,
    this.checkinTime,
    this.checkoutTime,
  });
}
