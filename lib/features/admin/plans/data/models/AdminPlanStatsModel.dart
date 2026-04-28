import '../../domain/entities/admin_plan_stats_entity.dart';

class AdminPlanStatsModel {
  final int totalPlans;
  final int totalMembers;
  final int activePlans;

  const AdminPlanStatsModel({
    required this.totalPlans,
    required this.totalMembers,
    required this.activePlans,
  });

  factory AdminPlanStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminPlanStatsModel(
      totalPlans: json['totalPlans'] as int,
      totalMembers: json['totalMembers'] as int,
      activePlans: json['activePlans'] as int,
    );
  }

  AdminPlanStatsEntity toEntity() => AdminPlanStatsEntity(
    totalPlans: totalPlans,
    totalMembers: totalMembers,
    activePlans: activePlans,
  );
}