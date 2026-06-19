import '../../domain/entities/checkin_stats.dart';

class CheckinStatsModel {
  final int todayCheckins;
  final int attendanceCount;
  final double attendanceGrowth;
  final int upcomingPTSessions;
  final int uniqueMembersAttended;
  final int absentMembers;

  const CheckinStatsModel({required this.todayCheckins, required this.attendanceCount,
    required this.attendanceGrowth, required this.upcomingPTSessions,
    required this.uniqueMembersAttended, required this.absentMembers});

  factory CheckinStatsModel.fromJson(Map<String, dynamic> json) => CheckinStatsModel(
    todayCheckins: json['todayCheckins'] ?? 0,
    attendanceCount: json['attendanceCount'] ?? 0,
    attendanceGrowth: (json['attendanceGrowth'] ?? 0).toDouble(),
    upcomingPTSessions: json['upcomingPTSessions'] ?? 0,
    uniqueMembersAttended: json['uniqueMembersAttended'] ?? 0,
    absentMembers: json['absentMembers'] ?? 0,
  );

  CheckinStats toEntity() => CheckinStats(todayCheckins: todayCheckins,
      attendanceCount: attendanceCount, attendanceGrowth: attendanceGrowth,
      upcomingPTSessions: upcomingPTSessions,
      uniqueMembersAttended: uniqueMembersAttended, absentMembers: absentMembers);
}