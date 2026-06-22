/// Result of a scan / manual check-in / manual checkout action.
class EmployeeCheckinActionEntity {
  final int employeeCheckinId;
  final int employeeId;
  final String employeeName;
  /// "CHECKED_IN" or "CHECKED_OUT" — tells the UI which snackbar copy to show.
  final String action;
  final String status;
  final DateTime checkinTime;
  final DateTime? checkoutTime;

  const EmployeeCheckinActionEntity({
    required this.employeeCheckinId,
    required this.employeeId,
    required this.employeeName,
    required this.action,
    required this.status,
    required this.checkinTime,
    this.checkoutTime,
  });
}
