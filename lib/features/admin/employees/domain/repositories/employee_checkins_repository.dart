import '../entities/employee_checkin_row_entity.dart';
import '../entities/employee_checkin_action_entity.dart';
import '../entities/branch_checkin_qr_entity.dart';

abstract class EmployeeCheckinsRepository {
  Future<List<EmployeeCheckinRowEntity>> getTodayCheckins({required int branchId});
  Future<BranchCheckinQrEntity> getBranchQr({required int branchId});
  Future<EmployeeCheckinActionEntity> scan({required String token});
  Future<EmployeeCheckinActionEntity> manualCheckin({required int employeeId, int? branchId});
  Future<EmployeeCheckinActionEntity> manualCheckout({required int employeeCheckinId});
}
