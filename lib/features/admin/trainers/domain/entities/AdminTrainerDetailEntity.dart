// =============================================================================
// FILE: lib/features/admin/trainers/domain/entities/admin_trainer_detail_entity.dart
// =============================================================================

class AvailabilitySlotEntity {
  final int     weekday;
  final String? startTime;
  final String? endTime;
  final int?    branchId;

  const AvailabilitySlotEntity({
    required this.weekday,
    this.startTime,
    this.endTime,
    this.branchId,
  });
}

class AdminTrainerDetailEntity {
  final int          trainerId;
  final String       fullName;
  final String?      email;
  final String?      phone;
  final String       status;
  final List<String> specialties;
  final List<int>    branchIds;
  final List<String> branchNames;
  final int?         yearsOfExperience;
  final String?      notes;
  final List<AvailabilitySlotEntity> availabilitySchedule;

  const AdminTrainerDetailEntity({
    required this.trainerId,
    required this.fullName,
    this.email,
    this.phone,
    required this.status,
    required this.specialties,
    required this.branchIds,
    required this.branchNames,
    this.yearsOfExperience,
    this.notes,
    required this.availabilitySchedule,
  });
}
 