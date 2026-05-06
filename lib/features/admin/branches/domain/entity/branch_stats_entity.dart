// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/domain/entity/branch_stats_entity.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:equatable/equatable.dart';

class BranchStatsEntity extends Equatable {
  final int activeBranches;
  final int totalMembers;
  final double monthlyRevenue;

  const BranchStatsEntity({
    required this.activeBranches,
    required this.totalMembers,
    required this.monthlyRevenue,
  });

  @override
  List<Object?> get props => [activeBranches, totalMembers, monthlyRevenue];
}