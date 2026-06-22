import '../../domain/entities/employee_payment_entity.dart';

class EmployeePaymentModel {
  final int paymentId;
  final int employeeId;
  final String? employeeName;
  final double amount;
  final DateTime paymentDate;
  final String? note;
  final int expenseId;
  final DateTime createdAt;

  const EmployeePaymentModel({
    required this.paymentId,
    required this.employeeId,
    this.employeeName,
    required this.amount,
    required this.paymentDate,
    this.note,
    required this.expenseId,
    required this.createdAt,
  });

  factory EmployeePaymentModel.fromJson(Map<String, dynamic> json) {
    return EmployeePaymentModel(
      paymentId: (json['paymentId'] as num).toInt(),
      employeeId: (json['employeeId'] as num).toInt(),
      employeeName: json['employeeName'] as String?,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      note: json['note'] as String?,
      expenseId: (json['expenseId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  EmployeePaymentEntity toEntity() => EmployeePaymentEntity(
        paymentId: paymentId,
        employeeId: employeeId,
        employeeName: employeeName,
        amount: amount,
        paymentDate: paymentDate,
        note: note,
        expenseId: expenseId,
        createdAt: createdAt,
      );
}
