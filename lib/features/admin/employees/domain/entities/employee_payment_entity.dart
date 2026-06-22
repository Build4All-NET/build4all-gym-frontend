class EmployeePaymentEntity {
  final int paymentId;
  final int employeeId;
  final String? employeeName;
  final double amount;
  final DateTime paymentDate;
  final String? note;
  final int expenseId;
  final DateTime createdAt;

  const EmployeePaymentEntity({
    required this.paymentId,
    required this.employeeId,
    this.employeeName,
    required this.amount,
    required this.paymentDate,
    this.note,
    required this.expenseId,
    required this.createdAt,
  });
}
