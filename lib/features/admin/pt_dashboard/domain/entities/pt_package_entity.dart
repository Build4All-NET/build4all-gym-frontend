// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/entities/pt_package_entity.dart
// LAYER: Domain — Entity
//
// Admin-specific PT package entity.
// Includes trainerId/trainerName so admin can show a "By <Trainer>" badge.
// =============================================================================

class PtPackageEntity {
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
  final String? trainerName;    // resolved in screen from trainers list
  final int branchId;
  final int tenantId;
  final int? ptServiceId;
  final DateTime? createdAt;
  final String commissionType; // 'SALARY' | 'COMMISSION'
  final double? commissionPercentage;

  const PtPackageEntity({
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
    this.trainerName,
    required this.branchId,
    required this.tenantId,
    this.ptServiceId,
    this.createdAt,
    this.commissionType = 'SALARY',
    this.commissionPercentage,
  });

  PtPackageEntity copyWith({
    bool? isActive,
    String? trainerName,
  }) {
    return PtPackageEntity(
      id: id,
      name: name,
      packageType: packageType,
      numberOfSessions: numberOfSessions,
      sessionDurationMinutes: sessionDurationMinutes,
      daysAvailable: daysAvailable,
      minDaysPerWeek: minDaysPerWeek,
      maxDaysPerWeek: maxDaysPerWeek,
      maxConcurrentSessions: maxConcurrentSessions,
      price: price,
      salePrice: salePrice,
      finalPrice: finalPrice,
      isActive: isActive ?? this.isActive,
      trainerId: trainerId,
      trainerName: trainerName ?? this.trainerName,
      branchId: branchId,
      tenantId: tenantId,
      ptServiceId: ptServiceId,
      createdAt: createdAt,
      commissionType: commissionType,
      commissionPercentage: commissionPercentage,
    );
  }
}