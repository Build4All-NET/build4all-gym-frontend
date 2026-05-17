// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/models/pt_package_model.dart
// LAYER: Data — Model
//
// Raw JSON-to-Dart mapping from backend response.
// toEntity() converts it to the domain entity used by BLoC and UI.
// =============================================================================

import '../../domain/entities/pt_package_entity.dart';

class PtPackageModel {
  final int id;
  final String name;
  final String packageType;
  final int numberOfSessions;
  final int sessionDurationMinutes;
  final int daysAvailable;
  final int minDaysPerWeek;
  final int maxDaysPerWeek;
  final int maxConcurrentSessions;
  final double price;
  final double? salePrice;
  final double finalPrice;
  final bool isActive;
  final int trainerId;
  final int branchId;
  final int tenantId;
  final int? ptServiceId;
  final DateTime? createdAt;

  const PtPackageModel({
    required this.id,
    required this.name,
    required this.packageType,
    required this.numberOfSessions,
    required this.sessionDurationMinutes,
    required this.daysAvailable,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    required this.maxConcurrentSessions,
    required this.price,
    this.salePrice,
    required this.finalPrice,
    required this.isActive,
    required this.trainerId,
    required this.branchId,
    required this.tenantId,
    this.ptServiceId,
    this.createdAt,
  });

  factory PtPackageModel.fromJson(Map<String, dynamic> json) {
    return PtPackageModel(
      id:                     (json['id'] as num?)?.toInt() ?? 0,
      name:                   json['name']        as String? ?? '',
      packageType:            json['packageType'] as String? ?? '',
      numberOfSessions:       (json['numberOfSessions']       as num?)?.toInt() ?? 0,
      sessionDurationMinutes: (json['sessionDurationMinutes'] as num?)?.toInt() ?? 60,
      daysAvailable:          (json['daysAvailable']          as num?)?.toInt() ?? 0,
      minDaysPerWeek:         (json['minDaysPerWeek']         as num?)?.toInt() ?? 1,
      maxDaysPerWeek:         (json['maxDaysPerWeek']         as num?)?.toInt() ?? 1,
      maxConcurrentSessions:  (json['maxConcurrentSessions']  as num?)?.toInt() ?? 1,
      price:                  (json['price']     as num?)?.toDouble() ?? 0.0,
      salePrice:              (json['salePrice'] as num?)?.toDouble(),
      finalPrice:             (json['finalPrice']  as num?)?.toDouble()
          ?? (json['salePrice']   as num?)?.toDouble()
          ?? (json['price']        as num?)?.toDouble()
          ?? 0.0,
      isActive:   (json['isActive'] as bool?) ?? true,
      trainerId:  (json['trainerId']  as num?)?.toInt() ?? 0,
      branchId:   (json['branchId']   as num?)?.toInt() ?? 0,
      tenantId:   (json['tenantId']   as num?)?.toInt() ?? 0,
      ptServiceId:(json['ptServiceId'] as num?)?.toInt(),
      createdAt:  json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  // ── model → entity (used by repository impl) ─────────────────────────────

  PtPackageEntity toEntity() {
    return PtPackageEntity(
      id:                     id,
      name:                   name,
      packageType:            packageType,
      numberOfSessions:       numberOfSessions,
      sessionDurationMinutes: sessionDurationMinutes,
      daysAvailable:          daysAvailable,
      minDaysPerWeek:         minDaysPerWeek,
      maxDaysPerWeek:         maxDaysPerWeek,
      maxConcurrentSessions:  maxConcurrentSessions,
      price:                  price,
      salePrice:              salePrice,
      finalPrice:             finalPrice,
      isActive:               isActive,
      trainerId:              trainerId,
      branchId:               branchId,
      tenantId:               tenantId,
      ptServiceId:            ptServiceId,
      createdAt:              createdAt,
    );
  }
}