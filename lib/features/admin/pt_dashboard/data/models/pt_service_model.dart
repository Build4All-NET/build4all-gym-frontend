// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/models/pt_service_model.dart
// LAYER: Data — Model
//
// Maps pt_services DB table response.
// toEntity() converts to domain entity.
// =============================================================================

import '../../domain/entities/pt_service_entity.dart';

class PtServiceModel {
  final int serviceId;
  final String name;
  final String? description;
  final int durationMinutes;
  final double price;
  final double commissionPercentage;
  final bool isActive;
  final int trainerId;
  final int tenantId;

  const PtServiceModel({
    required this.serviceId,
    required this.name,
    this.description,
    required this.durationMinutes,
    required this.price,
    required this.commissionPercentage,
    required this.isActive,
    required this.trainerId,
    required this.tenantId,
  });

  factory PtServiceModel.fromJson(Map<String, dynamic> json) {
    return PtServiceModel(
      serviceId:       (json['serviceId'] as num?)?.toInt()
          ?? (json['id']        as num?)?.toInt()
          ?? 0,
      name:            json['name']        as String? ?? '',
      description:     json['description'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 60,
      price:           (json['price'] as num?)?.toDouble() ?? 0.0,
      commissionPercentage: (json['commissionPercentage'] as num?)?.toDouble() ?? 0.0,
      isActive:        (json['isActive'] as bool?) ?? true,
      trainerId:       (json['trainerId'] as num?)?.toInt() ?? 0,
      tenantId:        (json['tenantId']  as num?)?.toInt() ?? 0,
    );
  }

  // ── model → entity ────────────────────────────────────────────────────────

  PtServiceEntity toEntity() {
    return PtServiceEntity(
      serviceId:       serviceId,
      name:            name,
      description:     description,
      durationMinutes: durationMinutes,
      price:           price,
      commissionPercentage: commissionPercentage,
      isActive:        isActive,
      trainerId:       trainerId,
      tenantId:        tenantId,
    );
  }
}