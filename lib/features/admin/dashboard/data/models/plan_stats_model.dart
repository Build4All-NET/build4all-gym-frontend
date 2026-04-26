import '../../domain/entities/plan_stats.dart';

class PlanStatsModel {
  final int totalPlans;
  final int activePlans;
  final int expiredPlans;

  const PlanStatsModel({required this.totalPlans, required this.activePlans, required this.expiredPlans});

  factory PlanStatsModel.fromJson(Map<String, dynamic> json) => PlanStatsModel(
    totalPlans: json['totalPlans'] ?? 0,
    activePlans: json['activePlans'] ?? 0,
    expiredPlans: json['expiredPlans'] ?? 0,
  );

  PlanStats toEntity() => PlanStats(totalPlans: totalPlans, activePlans: activePlans, expiredPlans: expiredPlans);
}