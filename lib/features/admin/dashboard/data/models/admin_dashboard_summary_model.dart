import '../../domain/entities/admin_dashboard_summary.dart';
import 'member_stats_model.dart';
import 'plan_stats_model.dart';
import 'checkin_stats_model.dart';
import 'revenue_model.dart';
import 'recent_activity_model.dart';

class AdminDashboardSummaryModel {
  final String period;
  final MemberStatsModel members;
  final PlanStatsModel plans;
  final CheckinStatsModel checkins;
  final RevenueModel? revenue;
  final RecentActivityModel recentActivity;

  const AdminDashboardSummaryModel({required this.period, required this.members,
    required this.plans, required this.checkins, this.revenue, required this.recentActivity});

  factory AdminDashboardSummaryModel.fromJson(Map<String, dynamic> json) => AdminDashboardSummaryModel(
    period: json['period'] ?? 'today',
    members: MemberStatsModel.fromJson(json['members'] ?? {}),
    plans: PlanStatsModel.fromJson(json['plans'] ?? {}),
    checkins: CheckinStatsModel.fromJson(json['checkins'] ?? {}),
    revenue: json['revenue'] != null ? RevenueModel.fromJson(json['revenue']) : null,
    recentActivity: RecentActivityModel.fromJson(json['recentActivity'] ?? {}),
  );

  AdminDashboardSummary toEntity() => AdminDashboardSummary(
    period: period, members: members.toEntity(), plans: plans.toEntity(),
    checkins: checkins.toEntity(), revenue: revenue?.toEntity(),
    recentActivity: recentActivity.toEntity(),
  );
}