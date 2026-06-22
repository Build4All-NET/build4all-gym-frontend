import '../entities/employee_entity.dart';
import '../entities/employee_payment_entity.dart';
import '../entities/eligible_staff_entity.dart';
import '../entities/pay_employee_result_entity.dart';
import '../repositories/admin_employees_repository.dart';
import '../../data/models/create_employee_request_model.dart';
import '../../data/models/update_employee_request_model.dart';
import '../../data/models/pay_employee_request_model.dart';

class GetEmployeesUseCase {
  final AdminEmployeesRepository repository;
  GetEmployeesUseCase({required this.repository});
  Future<List<EmployeeEntity>> call({
    int? branchId,
    String? employeeType,
    String? status,
    String? search,
  }) =>
      repository.getEmployees(
        branchId: branchId,
        employeeType: employeeType,
        status: status,
        search: search,
      );
}

class GetEmployeeTypesUseCase {
  final AdminEmployeesRepository repository;
  GetEmployeeTypesUseCase({required this.repository});
  Future<List<String>> call() => repository.getTypes();
}

class GetEligibleStaffUseCase {
  final AdminEmployeesRepository repository;
  GetEligibleStaffUseCase({required this.repository});
  Future<List<EligibleStaffEntity>> call() => repository.getEligibleStaff();
}

class CreateEmployeeUseCase {
  final AdminEmployeesRepository repository;
  CreateEmployeeUseCase({required this.repository});
  Future<EmployeeEntity> call(CreateEmployeeRequestModel request) =>
      repository.createEmployee(request);
}

class UpdateEmployeeUseCase {
  final AdminEmployeesRepository repository;
  UpdateEmployeeUseCase({required this.repository});
  Future<EmployeeEntity> call(int employeeId, UpdateEmployeeRequestModel request) =>
      repository.updateEmployee(employeeId, request);
}

class DeleteEmployeeUseCase {
  final AdminEmployeesRepository repository;
  DeleteEmployeeUseCase({required this.repository});
  Future<void> call(int employeeId) => repository.deleteEmployee(employeeId);
}

class PayEmployeeUseCase {
  final AdminEmployeesRepository repository;
  PayEmployeeUseCase({required this.repository});
  Future<PayEmployeeResultEntity> call(int employeeId, PayEmployeeRequestModel request) =>
      repository.payEmployee(employeeId, request);
}

class GetEmployeePaymentsUseCase {
  final AdminEmployeesRepository repository;
  GetEmployeePaymentsUseCase({required this.repository});
  Future<List<EmployeePaymentEntity>> call(int employeeId) => repository.getPayments(employeeId);
}
