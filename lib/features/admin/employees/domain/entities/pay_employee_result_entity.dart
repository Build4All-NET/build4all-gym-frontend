import 'employee_entity.dart';
import 'employee_payment_entity.dart';

/// Result of POST /{employeeId}/pay — the refreshed employee card plus the
/// payment record just created.
class PayEmployeeResultEntity {
  final EmployeeEntity employee;
  final EmployeePaymentEntity payment;

  const PayEmployeeResultEntity({
    required this.employee,
    required this.payment,
  });
}
