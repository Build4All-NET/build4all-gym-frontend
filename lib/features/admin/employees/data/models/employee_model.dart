import '../../domain/entities/employee_entity.dart';

class EmployeeModel {
  final int employeeId;
  final String? fullName;
  final String? phone;
  final String? email;
  final String employeeType;
  final int branchId;
  final String branchName;
  final double salaryAmount;
  final String payFrequency;
  final DateTime? hireDate;
  final String status;
  final DateTime? lastPaidDate;
  final DateTime? nextDueDate;
  final String dueStatus;
  final int? linkedUserId;
  final String? notes;
  final DateTime createdAt;
  final int daysWorkedThisMonth;

  const EmployeeModel({
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

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: (json['employeeId'] as num).toInt(),
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      employeeType: json['employeeType'] as String,
      branchId: (json['branchId'] as num).toInt(),
      branchName: json['branchName'] as String? ?? '',
      salaryAmount: (json['salaryAmount'] as num).toDouble(),
      payFrequency: json['payFrequency'] as String,
      hireDate: json['hireDate'] != null ? DateTime.parse(json['hireDate'] as String) : null,
      status: json['status'] as String? ?? 'active',
      lastPaidDate: json['lastPaidDate'] != null ? DateTime.parse(json['lastPaidDate'] as String) : null,
      nextDueDate: json['nextDueDate'] != null ? DateTime.parse(json['nextDueDate'] as String) : null,
      dueStatus: json['dueStatus'] as String? ?? 'OVERDUE',
      linkedUserId: (json['linkedUserId'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      daysWorkedThisMonth: (json['daysWorkedThisMonth'] as num?)?.toInt() ?? 0,
    );
  }

  EmployeeEntity toEntity() => EmployeeEntity(
        employeeId: employeeId,
        fullName: fullName,
        phone: phone,
        email: email,
        employeeType: employeeType,
        branchId: branchId,
        branchName: branchName,
        salaryAmount: salaryAmount,
        payFrequency: payFrequency,
        hireDate: hireDate,
        status: status,
        lastPaidDate: lastPaidDate,
        nextDueDate: nextDueDate,
        dueStatus: dueStatus,
        linkedUserId: linkedUserId,
        notes: notes,
        createdAt: createdAt,
        daysWorkedThisMonth: daysWorkedThisMonth,
      );
}
