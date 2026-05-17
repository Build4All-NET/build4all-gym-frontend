import '../../../../../core/error/failures.dart';
import '../entities/pt_booking_response_entity.dart';
import '../repositories/member_pt_repository.dart';

/// Use case for creating a PT booking.
///
/// The presentation layer calls this usecase.
/// The usecase calls the repository.
/// The repository decides where data comes from: API, cache, etc.
class CreateBookingUseCase {
  final MemberPtRepository _repository;

  const CreateBookingUseCase(this._repository);

  Future<({PtBookingResponseEntity? data, Failure? failure})> call({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  }) {
    return _repository.createBooking(
      trainerId: trainerId,
      startTime: startTime,
      endTime: endTime,
      notes: notes,
    );
  }
}