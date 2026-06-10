// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/branches/data/models/branch_card_model.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entity/branch_entity.dart';

class BranchCardModel extends BranchEntity {
  const BranchCardModel({
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
    super.isOpen24Hours,
  });

  factory BranchCardModel.fromJson(Map<String, dynamic> json) {
    return BranchCardModel(
      branchId:       json['branchId']?.toString() ?? '',
      name:           json['name']            as String,
      city:           json['city']            as String?,
      status:         json['status']          as String? ?? 'ACTIVE',
      memberCount:    (json['memberCount']    as num?)?.toInt() ?? 0,
      trainerCount:   (json['trainerCount']   as num?)?.toInt() ?? 0,
      staffCount:     (json['staffCount']     as num?)?.toInt() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
      openingTime:    json['openingTime']     as String?,
      closingTime:    json['closingTime']     as String?,
      isOpen24Hours:  json['isOpen24Hours']   as bool? ?? false,
    );
  }
}
