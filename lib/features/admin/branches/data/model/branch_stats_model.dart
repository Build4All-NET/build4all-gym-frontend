// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/data/model/branch_stats_model.dart
// ─────────────────────────────────────────────────────────────────────────────
import '../../domain/entity/branch_stats_entity.dart';

class BranchStatsModel extends BranchStatsEntity {
  const BranchStatsModel({
    required super.activeBranches,
    required super.totalMembers,
    required super.monthlyRevenue,
  });

  factory BranchStatsModel.fromJson(Map<String, dynamic> json) {
    return BranchStatsModel(
      activeBranches: (json['activeBranches'] as num?)?.toInt() ?? 0,
      totalMembers:   (json['totalMembers']   as num?)?.toInt() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}