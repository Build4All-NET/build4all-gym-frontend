import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/employee_payment_entity.dart';
import '../../domain/entities/eligible_staff_entity.dart';
import '../../domain/entities/pay_employee_result_entity.dart';
import '../../domain/repositories/admin_employees_repository.dart';
import '../services/admin_employees_remote_service.dart';
import '../models/create_employee_request_model.dart';
import '../models/update_employee_request_model.dart';
import '../models/pay_employee_request_model.dart';

class AdminEmployeesRepositoryImpl implements AdminEmployeesRepository {
  final AdminEmployeesRemoteDatasource remoteDatasource;

  AdminEmployeesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<EmployeeEntity>> getEmployees({
    int? branchId,
    String? employeeType,
    String? status,
    String? search,
  }) async {
    final models = await remoteDatasource.getEmployees(
      branchId: branchId,
      employeeType: employeeType,
      status: status,
      search: search,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<String>> getTypes() => remoteDatasource.getTypes();

  @override
  Future<List<EligibleStaffEntity>> getEligibleStaff() async {
    final models = await remoteDatasource.getEligibleStaff();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<EmployeeEntity> createEmployee(CreateEmployeeRequestModel request) async {
    final model = await remoteDatasource.createEmployee(request);
    return model.toEntity();
  }

  @override
  Future<EmployeeEntity> updateEmployee(int employeeId, UpdateEmployeeRequestModel request) async {
    final model = await remoteDatasource.updateEmployee(employeeId, request);
    return model.toEntity();
  }

  @override
  Future<void> deleteEmployee(int employeeId) => remoteDatasource.deleteEmployee(employeeId);

  @override
  Future<PayEmployeeResultEntity> payEmployee(int employeeId, PayEmployeeRequestModel request) async {
    final model = await remoteDatasource.payEmployee(employeeId, request);
    return model.toEntity();
  }

  @override
  Future<List<EmployeePaymentEntity>> getPayments(int employeeId) async {
    final models = await remoteDatasource.getPayments(employeeId);
    return models.map((m) => m.toEntity()).toList();
  }
}
