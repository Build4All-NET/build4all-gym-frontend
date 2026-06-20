// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/entities/pt_service_entity.dart
// LAYER: Domain — Entity
//
// Maps pt_services DB table.
// Includes trainerId so admin can show a "By <Trainer>" badge per service.
// =============================================================================

class PtServiceEntity {
  final int serviceId;
  final String name;
  final String? description;
  final int durationMinutes;
  final double price;
  final double commissionPercentage;
  final bool isActive;
  final int trainerId;
  final String? trainerName;    // resolved in screen from trainers list
  final int tenantId;

  const PtServiceEntity({
    required this.serviceId,
    required this.name,
    this.description,
    required this.durationMinutes,
    required this.price,
    required this.commissionPercentage,
    required this.isActive,
    required this.trainerId,
    this.trainerName,
    required this.tenantId,
  });

  PtServiceEntity copyWith({
    bool? isActive,
    String? trainerName,
  }) {
    return PtServiceEntity(
      serviceId: serviceId,
      name: name,
      description: description,
      durationMinutes: durationMinutes,
      price: price,
      commissionPercentage: commissionPercentage,
      isActive: isActive ?? this.isActive,
      trainerId: trainerId,
      trainerName: trainerName ?? this.trainerName,
      tenantId: tenantId,
    );
  }
}