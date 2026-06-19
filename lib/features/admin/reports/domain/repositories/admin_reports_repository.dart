import '../entities/financial_report_entity.dart';
import '../entities/attendance_report_entity.dart';

abstract class AdminReportsRepository {
  Future<FinancialReportEntity> getFinancial({DateTime? from, DateTime? to});
  Future<AttendanceReportEntity> getAttendance({DateTime? from, DateTime? to});
}
