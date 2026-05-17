// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/usecases/availability_usecases.dart
// LAYER: Domain — Use Cases
//
// CHANGES vs previous version:
//   - CreateAvailabilitySlotUseCase now accepts optional `specificDate`
//     (DateTime?) and forwards it to the repository.
//     Needed because DB trainer_availability.specific_date must be set when
//     is_recurring = false.
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/availability_entity.dart';
import '../repositories/availability_repository.dart';

// ── 1. Get slots ─────────────────────────────────────────────────────────────

class GetAvailabilitySlotsUseCase {
  final AvailabilityRepository _repository;
  const GetAvailabilitySlotsUseCase(this._repository);

  /// [trainerId] = null → admin mode, returns all trainers' slots.
  Future<({List<AvailabilityEntity>? data, Failure? failure})> call({
    int? trainerId,
    required int branchId,
  }) =>
      _repository.getSlots(trainerId: trainerId, branchId: branchId);
}

// ── 2. Create slot ───────────────────────────────────────────────────────────

class CreateAvailabilitySlotUseCase {
  final AvailabilityRepository _repository;
  const CreateAvailabilitySlotUseCase(this._repository);

  /// [specificDate] required when [recurring] = false.
  /// Maps to DB column trainer_availability.specific_date.
  Future<({AvailabilityEntity? data, Failure? failure})> call({
    required int trainerId,
    required int branchId,
    required int weekday,
    required String startTime,
    required String endTime,
    bool recurring = true,
    DateTime? specificDate,
  }) =>
      _repository.createSlot(
        trainerId:    trainerId,
        branchId:     branchId,
        weekday:      weekday,
        startTime:    startTime,
        endTime:      endTime,
        recurring:    recurring,
        specificDate: specificDate,
      );
}

// ── 3. Delete slot ───────────────────────────────────────────────────────────

class DeleteAvailabilitySlotUseCase {
  final AvailabilityRepository _repository;
  const DeleteAvailabilitySlotUseCase(this._repository);

  Future<({bool success, Failure? failure})> call(int availabilityId) =>
      _repository.deleteSlot(availabilityId);
}
