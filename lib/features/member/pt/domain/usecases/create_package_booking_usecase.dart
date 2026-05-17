import '../../../../../core/error/failures.dart';
import '../entities/pt_package_booking_response_entity.dart';
import '../repositories/member_pt_repository.dart';

/// Use case for creating a PT package booking.
///
/// New package flow:
/// - no dates
/// - no global selectedTime
/// - each selected weekday has its own time
///
/// Backend expects:
/// {
///   "packageId": 1,
///   "weeklySchedule": [
///     {
///       "day": "MONDAY",
///       "time": "09:00"
///     },
///     {
///       "day": "THURSDAY",
///       "time": "18:00"
///     }
///   ]
/// }
class CreatePackageBookingUseCase {
  final MemberPtRepository _repository;

  const CreatePackageBookingUseCase(this._repository);

  Future<({PtPackageBookingResponseEntity? data, Failure? failure})> call({
    required int packageId,
    required List<Map<String, dynamic>> weeklySchedule,
  }) {
    return _repository.createPackageBooking(
      packageId: packageId,
      weeklySchedule: weeklySchedule,
    );
  }
}