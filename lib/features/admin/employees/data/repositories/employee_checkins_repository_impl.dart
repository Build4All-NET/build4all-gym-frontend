import '../../domain/entities/employee_checkin_row_entity.dart';
import '../../domain/entities/employee_checkin_action_entity.dart';
import '../../domain/entities/branch_checkin_qr_entity.dart';
import '../../domain/repositories/employee_checkins_repository.dart';
import '../services/employee_checkins_remote_service.dart';

class EmployeeCheckinsRepositoryImpl implements EmployeeCheckinsRepository {
  final EmployeeCheckinsRemoteDatasource remoteDatasource;

  EmployeeCheckinsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<EmployeeCheckinRowEntity>> getTodayCheckins({required int branchId}) async {
    final models = await remoteDatasource.getTodayCheckins(branchId: branchId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<BranchCheckinQrEntity> getBranchQr({required int branchId}) async {
    final model = await remoteDatasource.getBranchQr(branchId: branchId);
    return model.toEntity();
  }

  @override
  Future<EmployeeCheckinActionEntity> scan({required String token}) async {
    final model = await remoteDatasource.scan(token: token);
    return model.toEntity();
  }

  @override
  Future<EmployeeCheckinActionEntity> manualCheckin({required int employeeId, int? branchId}) async {
    final model = await remoteDatasource.manualCheckin(employeeId: employeeId, branchId: branchId);
    return model.toEntity();
  }

  @override
  Future<EmployeeCheckinActionEntity> manualCheckout({required int employeeCheckinId}) async {
    final model = await remoteDatasource.manualCheckout(employeeCheckinId: employeeCheckinId);
    return model.toEntity();
  }
}
