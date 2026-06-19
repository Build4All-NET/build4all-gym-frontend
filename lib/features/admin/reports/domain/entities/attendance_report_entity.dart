import 'report_point_entity.dart';

/// Attendance report for a selected date range (Reports → Attendance tab).
class AttendanceReportEntity {
  final int totalCheckins;
  final int uniqueMembers;
  final double avgPerDay;
  final List<ReportPointEntity> checkinsSeries;

  const AttendanceReportEntity({
    required this.totalCheckins,
    required this.uniqueMembers,
    required this.avgPerDay,
    required this.checkinsSeries,
  });
}
