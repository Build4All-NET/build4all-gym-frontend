import '../../../../../core/error/failures.dart';
import '../entities/time_slot_entity.dart';
import '../repositories/member_pt_repository.dart';

/// Use case for loading recurring weekly available PT slots.
///
/// Used by PT package booking.
///
/// Backend endpoint:
/// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
///
/// Important:
/// - day must be a stable backend code:
///   MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY.
/// - no date is sent.
/// - returned slots come from trainer/PT availability.
class GetWeeklyAvailableSlotsUseCase {
  final MemberPtRepository _repository;

  const GetWeeklyAvailableSlotsUseCase(this._repository);

  Future<({List<TimeSlotEntity>? data, Failure? failure})> call({
    required int trainerId,
    required String day,
    int? packageId,
  }) {
    return _repository.getWeeklyAvailableSlots(
      trainerId: trainerId,
      day: day,
      packageId: packageId,
    );
  }
}