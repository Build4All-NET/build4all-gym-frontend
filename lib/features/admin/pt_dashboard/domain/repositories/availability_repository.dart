// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/repositories/availability_repository.dart
// LAYER: Domain — Repository contract
//
// CHANGES vs previous version:
//   - createSlot() now has optional `specificDate` (DateTime?) parameter.
//     DB column: trainer_availability.specific_date (date, nullable).
// =============================================================================

import '../../../../../../core/error/failures.dart';
import '../entities/availability_entity.dart';

abstract class AvailabilityRepository {
  // ── READ ───────────────────────────────────────────────────────────────────
  /// [trainerId] = null → returns slots for ALL trainers (admin view).
  /// [trainerId] = id   → returns slots for that trainer only.
  Future<({List<AvailabilityEntity>? data, Failure? failure})> getSlots({
    int? trainerId,
    required int branchId,
  });

  // ── CREATE ─────────────────────────────────────────────────────────────────
  /// Admin/owner must supply the target trainerId.
  Future<({AvailabilityEntity? data, Failure? failure})> createSlot({
    required int trainerId,
    required int branchId,
    required int weekday,
    required String startTime,
    required String endTime,
    bool recurring = true,
    DateTime? specificDate,
  });

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<({bool success, Failure? failure})> deleteSlot(int availabilityId);
}
