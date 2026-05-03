// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/trainers/domain/entities/trainer_availability_entity.dart
// ─────────────────────────────────────────────────────────────────────────────
class TrainerAvailabilityEntity {
  final int    weekday;
  final String startTime;
  final String endTime;
  const TrainerAvailabilityEntity({
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });
}