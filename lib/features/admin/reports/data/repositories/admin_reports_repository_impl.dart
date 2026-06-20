import '../../domain/entities/financial_report_entity.dart';
import '../../domain/entities/attendance_report_entity.dart';
import '../../domain/repositories/admin_reports_repository.dart';
import '../services/admin_reports_remote_service.dart';

class AdminReportsRepositoryImpl implements AdminReportsRepository {
  final AdminReportsRemoteDatasource remoteDatasource;

  AdminReportsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<FinancialReportEntity> getFinancial({DateTime? from, DateTime? to}) async {
    final model = await remoteDatasource.getFinancial(from: from, to: to);
    return model.toEntity();
  }

  @override
  Future<AttendanceReportEntity> getAttendance({DateTime? from, DateTime? to}) async {
    final model = await remoteDatasource.getAttendance(from: from, to: to);
    return model.toEntity();
  }
}
