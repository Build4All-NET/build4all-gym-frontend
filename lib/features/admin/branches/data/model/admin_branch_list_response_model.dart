// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/branches/data/models/admin_branch_list_response_model.dart
//
// Maps the full GET /api/admin/branches response.
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entity/branch_stats_entity.dart';
import 'branch_card_model.dart';

class AdminBranchListResponseModel {
  final BranchStatsEntity stats;
  final List<BranchCardModel> branches;

  const AdminBranchListResponseModel({
    required this.stats,
    required this.branches,
  });

  factory AdminBranchListResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminBranchListResponseModel(
      stats: _StatsModel.fromJson(
          json['stats'] as Map<String, dynamic>),
      branches: (json['branches'] as List<dynamic>)
          .map((e) => BranchCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// Internal stats model — no need for a separate file
class _StatsModel extends BranchStatsEntity {
  const _StatsModel({
    required super.activeBranches,
    required super.totalMembers,
    required super.monthlyRevenue,
  });

  factory _StatsModel.fromJson(Map<String, dynamic> json) {
    return _StatsModel(
      activeBranches: (json['activeBranches'] as num?)?.toInt() ?? 0,
      totalMembers:   (json['totalMembers']   as num?)?.toInt() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}