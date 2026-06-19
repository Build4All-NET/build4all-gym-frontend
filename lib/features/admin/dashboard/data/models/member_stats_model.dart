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
  final int birthdaysToday;
  final int expiringToday;
  final int expiring1to3Days;
  final int expiring4to7Days;
  final int expiring8to15Days;
  final int ptExpiringToday;
  final int ptExpiring1to7Days;
  final int ptExpiring8to15Days;

  const MemberStatsModel({
    required this.activeMembers, required this.activeMembersGrowth,
    required this.totalMembers, required this.pendingRenewals,
    required this.expiringPlansNext7Days, required this.canceledLast7Days,
    required this.churnRate, required this.churnRateVsLastMonth,
    required this.birthdaysToday, required this.expiringToday,
    required this.expiring1to3Days, required this.expiring4to7Days,
    required this.expiring8to15Days, required this.ptExpiringToday,
    required this.ptExpiring1to7Days, required this.ptExpiring8to15Days,
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
    birthdaysToday: json['birthdaysToday'] ?? 0,
    expiringToday: json['expiringToday'] ?? 0,
    expiring1to3Days: json['expiring1to3Days'] ?? 0,
    expiring4to7Days: json['expiring4to7Days'] ?? 0,
    expiring8to15Days: json['expiring8to15Days'] ?? 0,
    ptExpiringToday: json['ptExpiringToday'] ?? 0,
    ptExpiring1to7Days: json['ptExpiring1to7Days'] ?? 0,
    ptExpiring8to15Days: json['ptExpiring8to15Days'] ?? 0,
  );

  MemberStats toEntity() => MemberStats(
    activeMembers: activeMembers, activeMembersGrowth: activeMembersGrowth,
    totalMembers: totalMembers, pendingRenewals: pendingRenewals,
    expiringPlansNext7Days: expiringPlansNext7Days, canceledLast7Days: canceledLast7Days,
    churnRate: churnRate, churnRateVsLastMonth: churnRateVsLastMonth,
    birthdaysToday: birthdaysToday, expiringToday: expiringToday,
    expiring1to3Days: expiring1to3Days, expiring4to7Days: expiring4to7Days,
    expiring8to15Days: expiring8to15Days, ptExpiringToday: ptExpiringToday,
    ptExpiring1to7Days: ptExpiring1to7Days, ptExpiring8to15Days: ptExpiring8to15Days,
  );
}