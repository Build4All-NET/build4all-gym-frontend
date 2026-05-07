// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/domain/entity/branch_entity.dart
// One card in the branch list
// ─────────────────────────────────────────────────────────────────────────────
import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final String branchId;
  final String name;
  final String? city;
  final String status;          // "ACTIVE" | "INACTIVE"
  final int memberCount;
  final int trainerCount;
  final int staffCount;
  final double monthlyRevenue;
  final String? openingTime;    // "06:00"
  final String? closingTime;    // "22:00"

  const BranchEntity({
    required this.branchId,
    required this.name,
    this.city,
    required this.status,
    required this.memberCount,
    required this.trainerCount,
    required this.staffCount,
    required this.monthlyRevenue,
    this.openingTime,
    this.closingTime,
  });

  bool get isActive => status == 'ACTIVE';

  @override
  List<Object?> get props => [branchId, name, status];
}
 