part of 'employee_checkins_bloc.dart';

// =============================================================================
// FILE: employee_checkins_event.dart
// Each event = one user action or lifecycle trigger.
// =============================================================================

abstract class EmployeeCheckinsEvent {
  const EmployeeCheckinsEvent();
}

/// Fired on screen open and after any action that should refresh the list.
class LoadTodayEmployeeCheckins extends EmployeeCheckinsEvent {
  final bool silent;
  const LoadTodayEmployeeCheckins({this.silent = false});
}

/// Fired by the scanner sheet after the camera reads the branch's check-in QR.
/// Toggles: not checked in today -> check in; already active -> check out.
class ScanEmployeeCheckinEvent extends EmployeeCheckinsEvent {
  final String token;
  const ScanEmployeeCheckinEvent(this.token);
}

/// Admin/reception taps "Check In" on a row with no app account.
class ManualCheckinEvent extends EmployeeCheckinsEvent {
  final int employeeId;
  const ManualCheckinEvent(this.employeeId);
}

/// Admin/reception taps "Check Out" on a row (manual override).
class ManualCheckoutEvent extends EmployeeCheckinsEvent {
  final int employeeCheckinId;
  const ManualCheckoutEvent(this.employeeCheckinId);
}

/// Fired when the admin picks a different branch.
class ChangeEmployeeCheckinsBranch extends EmployeeCheckinsEvent {
  final int branchId;
  const ChangeEmployeeCheckinsBranch(this.branchId);
}
