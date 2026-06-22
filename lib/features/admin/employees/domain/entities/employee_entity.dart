class EmployeeEntity {
  final int employeeId;
  final String? fullName;
  final String? phone;
  final String? email;
  final String employeeType;
  final int branchId;
  final String branchName;
  final double salaryAmount;
  final String payFrequency; // MONTHLY | WEEKLY | DAILY
  final DateTime? hireDate;
  final String status; // active | inactive
  final DateTime? lastPaidDate;
  final DateTime? nextDueDate;

  /// UP_TO_DATE | DUE_SOON | OVERDUE — computed server-side from
  /// lastPaidDate/hireDate + payFrequency, never recomputed on the client.
  final String dueStatus;

  /// Set when this employee is also an app user (trainer/reception);
  /// null for a standalone employee with no app account.
  final int? linkedUserId;
  final String? notes;
  final DateTime createdAt;

  /// Distinct calendar days with at least one check-in this month — shown so
  /// HR can see attendance before paying. See EmployeeCheckinRepository.
  final int daysWorkedThisMonth;

  bool get isLinked => linkedUserId != null;
  bool get isOverdue => dueStatus == 'OVERDUE';
  bool get isDueSoon => dueStatus == 'DUE_SOON';
  bool get isActive => status == 'active';

  const EmployeeEntity({
    required this.employeeId,
    this.fullName,
    this.phone,
    this.email,
    required this.employeeType,
    required this.branchId,
    required this.branchName,
    required this.salaryAmount,
    required this.payFrequency,
    this.hireDate,
    required this.status,
    this.lastPaidDate,
    this.nextDueDate,
    required this.dueStatus,
    this.linkedUserId,
    this.notes,
    required this.createdAt,
    this.daysWorkedThisMonth = 0,
  });
}
