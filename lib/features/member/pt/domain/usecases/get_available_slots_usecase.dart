import '../../../../../core/error/failures.dart';
import '../entities/time_slot_entity.dart';
import '../repositories/member_pt_repository.dart';

class GetAvailableSlotsUseCase {
  final MemberPtRepository _repository;

  GetAvailableSlotsUseCase(this._repository);

  Future<({List<TimeSlotEntity>? data, Failure? failure})> call({
    required int trainerId,
    required int branchId,
    required int serviceId,
    required DateTime date,
  }) {
    return _repository.getAvailableSlots(
      trainerId: trainerId,
      branchId: branchId,
      serviceId: serviceId,
      date: date,
    );
  }
}