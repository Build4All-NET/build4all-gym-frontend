// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/branches/data/models/branch_detail_model.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entity/branch_detail_entity.dart';

class BranchDetailModel extends BranchDetailEntity {
  const BranchDetailModel({
    required super.branchId,
    required super.name,
    super.city,
    required super.status,
    super.phone,
    super.email,
    super.address,
    super.openingTime,
    super.closingTime,
    super.isOpen24Hours,
    required super.memberCount,
    required super.trainerCount,
    required super.staffCount,
    required super.monthlyRevenue,
  });

  factory BranchDetailModel.fromJson(Map<String, dynamic> json) {
    return BranchDetailModel(
      branchId:       json['branchId']?.toString() ?? '',
      name:           json['name']            as String,
      city:           json['city']            as String?,
      status:         json['status']          as String? ?? 'ACTIVE',
      phone:          json['phone']           as String?,
      email:          json['email']           as String?,
      address:        json['address']         as String?,
      openingTime:    json['openingTime']     as String?,
      closingTime:    json['closingTime']     as String?,
      isOpen24Hours:  json['isOpen24Hours']   as bool? ?? false,
      memberCount:    (json['memberCount']    as num?)?.toInt() ?? 0,
      trainerCount:   (json['trainerCount']   as num?)?.toInt() ?? 0,
      staffCount:     (json['staffCount']     as num?)?.toInt() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}