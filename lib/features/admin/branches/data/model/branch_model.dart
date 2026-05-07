// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/data/model/branch_model.dart
// ─────────────────────────────────────────────────────────────────────────────
import '../../domain/entity/branch_entity.dart';

class BranchModel extends BranchEntity {
  const BranchModel({
    required super.branchId,
    required super.name,
    super.city,
    required super.status,
    required super.memberCount,
    required super.trainerCount,
    required super.staffCount,
    required super.monthlyRevenue,
    super.openingTime,
    super.closingTime,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId:       json['branchId']       as String,
      name:           json['name']           as String,
      city:           json['city']           as String?,
      status:         json['status']         as String? ?? 'ACTIVE',
      memberCount:    (json['memberCount']   as num?)?.toInt() ?? 0,
      trainerCount:   (json['trainerCount']  as num?)?.toInt() ?? 0,
      staffCount:     (json['staffCount']    as num?)?.toInt() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
      openingTime:    json['openingTime']    as String?,
      closingTime:    json['closingTime']    as String?,
    );
  }
}