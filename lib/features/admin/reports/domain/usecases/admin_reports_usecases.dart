import '../entities/financial_report_entity.dart';
import '../entities/attendance_report_entity.dart';
import '../repositories/admin_reports_repository.dart';

class GetFinancialReportUseCase {
  final AdminReportsRepository repository;
  GetFinancialReportUseCase({required this.repository});
  Future<FinancialReportEntity> call({DateTime? from, DateTime? to}) =>
      repository.getFinancial(from: from, to: to);
}

class GetAttendanceReportUseCase {
  final AdminReportsRepository repository;
  GetAttendanceReportUseCase({required this.repository});
  Future<AttendanceReportEntity> call({DateTime? from, DateTime? to}) =>
      repository.getAttendance(from: from, to: to);
}
