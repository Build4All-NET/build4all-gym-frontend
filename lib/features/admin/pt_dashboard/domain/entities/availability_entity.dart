// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/entities/availability_entity.dart
// LAYER: Domain — Entity
//
// Maps trainer_availability DB table.
// Includes trainerId so admin can show a "By <Trainer>" badge per slot.
// =============================================================================

class AvailabilityEntity {
  final int availabilityId;
  final int trainerId;
  final String? trainerName;    // resolved in screen from trainers list
  final int branchId;
  /// 1 = Monday … 7 = Sunday  (matches DB weekday column)
  final int weekday;
  final String startTime;   // "HH:mm"
  final String endTime;     // "HH:mm"
  final bool isRecurring;
  final DateTime? specificDate;

  const AvailabilityEntity({
    required this.availabilityId,
    required this.trainerId,
    this.trainerName,
    required this.branchId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    this.specificDate,
  });

  AvailabilityEntity copyWith({String? trainerName}) {
    return AvailabilityEntity(
      availabilityId: availabilityId,
      trainerId: trainerId,
      trainerName: trainerName ?? this.trainerName,
      branchId: branchId,
      weekday: weekday,
      startTime: startTime,
      endTime: endTime,
      isRecurring: isRecurring,
      specificDate: specificDate,
    );
  }
}