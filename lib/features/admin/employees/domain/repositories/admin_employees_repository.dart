import '../entities/employee_entity.dart';
import '../entities/employee_payment_entity.dart';
import '../entities/eligible_staff_entity.dart';
import '../entities/pay_employee_result_entity.dart';
import '../../data/models/create_employee_request_model.dart';
import '../../data/models/update_employee_request_model.dart';
import '../../data/models/pay_employee_request_model.dart';

abstract class AdminEmployeesRepository {
  Future<List<EmployeeEntity>> getEmployees({
    int? branchId,
    String? employeeType,
    String? status,
    String? search,
  });
  Future<List<String>> getTypes();
  Future<List<EligibleStaffEntity>> getEligibleStaff();
  Future<EmployeeEntity> createEmployee(CreateEmployeeRequestModel request);
  Future<EmployeeEntity> updateEmployee(int employeeId, UpdateEmployeeRequestModel request);
  Future<void> deleteEmployee(int employeeId);
  Future<PayEmployeeResultEntity> payEmployee(int employeeId, PayEmployeeRequestModel request);
  Future<List<EmployeePaymentEntity>> getPayments(int employeeId);
}
