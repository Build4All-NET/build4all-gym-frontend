import '../entities/employee_checkin_row_entity.dart';
import '../entities/employee_checkin_action_entity.dart';
import '../entities/branch_checkin_qr_entity.dart';
import '../repositories/employee_checkins_repository.dart';

class GetTodayEmployeeCheckinsUseCase {
  final EmployeeCheckinsRepository repository;
  GetTodayEmployeeCheckinsUseCase({required this.repository});
  Future<List<EmployeeCheckinRowEntity>> call({required int branchId}) =>
      repository.getTodayCheckins(branchId: branchId);
}

class GetBranchCheckinQrUseCase {
  final EmployeeCheckinsRepository repository;
  GetBranchCheckinQrUseCase({required this.repository});
  Future<BranchCheckinQrEntity> call({required int branchId}) =>
      repository.getBranchQr(branchId: branchId);
}

class ScanEmployeeCheckinUseCase {
  final EmployeeCheckinsRepository repository;
  ScanEmployeeCheckinUseCase({required this.repository});
  Future<EmployeeCheckinActionEntity> call({required String token}) =>
      repository.scan(token: token);
}

class ManualCheckinUseCase {
  final EmployeeCheckinsRepository repository;
  ManualCheckinUseCase({required this.repository});
  Future<EmployeeCheckinActionEntity> call({required int employeeId, int? branchId}) =>
      repository.manualCheckin(employeeId: employeeId, branchId: branchId);
}

class ManualCheckoutUseCase {
  final EmployeeCheckinsRepository repository;
  ManualCheckoutUseCase({required this.repository});
  Future<EmployeeCheckinActionEntity> call({required int employeeCheckinId}) =>
      repository.manualCheckout(employeeCheckinId: employeeCheckinId);
}
