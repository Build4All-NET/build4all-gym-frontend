import '../../domain/entities/checkin_stats.dart';

class CheckinStatsModel {
  final int todayCheckins;
  final int attendanceCount;
  final double attendanceGrowth;
  final int upcomingPTSessions;

  const CheckinStatsModel({required this.todayCheckins, required this.attendanceCount,
    required this.attendanceGrowth, required this.upcomingPTSessions});

  factory CheckinStatsModel.fromJson(Map<String, dynamic> json) => CheckinStatsModel(
    todayCheckins: json['todayCheckins'] ?? 0,
    attendanceCount: json['attendanceCount'] ?? 0,
    attendanceGrowth: (json['attendanceGrowth'] ?? 0).toDouble(),
    upcomingPTSessions: json['upcomingPTSessions'] ?? 0,
  );

  CheckinStats toEntity() => CheckinStats(todayCheckins: todayCheckins,
      attendanceCount: attendanceCount, attendanceGrowth: attendanceGrowth,
      upcomingPTSessions: upcomingPTSessions);
}