import '../../domain/entities/member_stats.dart';

class MemberStatsModel {
  final int activeMembers;
  final double activeMembersGrowth;
  final int totalMembers;
  final int pendingRenewals;
  final int expiringPlansNext7Days;
  final int canceledLast7Days;
  final double churnRate;
  final double churnRateVsLastMonth;

  const MemberStatsModel({
    required this.activeMembers, required this.activeMembersGrowth,
    required this.totalMembers, required this.pendingRenewals,
    required this.expiringPlansNext7Days, required this.canceledLast7Days,
    required this.churnRate, required this.churnRateVsLastMonth,
  });

  factory MemberStatsModel.fromJson(Map<String, dynamic> json) => MemberStatsModel(
    activeMembers: json['activeMembers'] ?? 0,
    activeMembersGrowth: (json['activeMembersGrowth'] ?? 0).toDouble(),
    totalMembers: json['totalMembers'] ?? 0,
    pendingRenewals: json['pendingRenewals'] ?? 0,
    expiringPlansNext7Days: json['expiringPlansNext7Days'] ?? 0,
    canceledLast7Days: json['canceledLast7Days'] ?? 0,
    churnRate: (json['churnRate'] ?? 0).toDouble(),
    churnRateVsLastMonth: (json['churnRateVsLastMonth'] ?? 0).toDouble(),
  );

  MemberStats toEntity() => MemberStats(
    activeMembers: activeMembers, activeMembersGrowth: activeMembersGrowth,
    totalMembers: totalMembers, pendingRenewals: pendingRenewals,
    expiringPlansNext7Days: expiringPlansNext7Days, canceledLast7Days: canceledLast7Days,
    churnRate: churnRate, churnRateVsLastMonth: churnRateVsLastMonth,
  );
}