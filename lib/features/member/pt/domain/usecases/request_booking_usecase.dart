import '../../../../../core/error/failures.dart';

import '../entities/pt_booking_response_entity.dart';
import '../repositories/member_pt_repository.dart';

class RequestBookingUseCase {
  final MemberPtRepository _repository;

  const RequestBookingUseCase(this._repository);

  Future<({PtBookingResponseEntity? data, Failure? failure})> call({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  }) {
    return _repository.requestBooking(
      trainerId: trainerId,
      startTime: startTime,
      endTime: endTime,
      notes: notes,
    );
  }
}