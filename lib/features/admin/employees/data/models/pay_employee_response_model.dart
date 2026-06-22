import '../../domain/entities/pay_employee_result_entity.dart';
import 'employee_model.dart';
import 'employee_payment_model.dart';

class PayEmployeeResponseModel {
  final EmployeeModel employee;
  final EmployeePaymentModel payment;

  const PayEmployeeResponseModel({
    required this.employee,
    required this.payment,
  });

  factory PayEmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    return PayEmployeeResponseModel(
      employee: EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
      payment: EmployeePaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }

  PayEmployeeResultEntity toEntity() => PayEmployeeResultEntity(
        employee: employee.toEntity(),
        payment: payment.toEntity(),
      );
}
