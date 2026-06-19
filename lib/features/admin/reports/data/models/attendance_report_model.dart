import '../../domain/entities/attendance_report_entity.dart';
import 'report_point_model.dart';

class AttendanceReportModel {
  final int totalCheckins;
  final int uniqueMembers;
  final double avgPerDay;
  final List<ReportPointModel> checkinsSeries;

  const AttendanceReportModel({
    required this.totalCheckins,
    required this.uniqueMembers,
    required this.avgPerDay,
    required this.checkinsSeries,
  });

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      totalCheckins: (json['totalCheckins'] as num?)?.toInt() ?? 0,
      uniqueMembers: (json['uniqueMembers'] as num?)?.toInt() ?? 0,
      avgPerDay: (json['avgPerDay'] as num?)?.toDouble() ?? 0.0,
      checkinsSeries: ((json['checkinsSeries'] as List<dynamic>?) ?? const [])
          .map((e) => ReportPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  AttendanceReportEntity toEntity() => AttendanceReportEntity(
        totalCheckins: totalCheckins,
        uniqueMembers: uniqueMembers,
        avgPerDay: avgPerDay,
        checkinsSeries: checkinsSeries.map((e) => e.toEntity()).toList(),
      );
}
