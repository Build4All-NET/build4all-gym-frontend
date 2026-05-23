import '../../../../../core/error/failures.dart';
import '../entities/pt_package_booking_response_entity.dart';
import '../repositories/member_pt_repository.dart';

class CreatePackageBookingUseCase {
  final MemberPtRepository _repository;

  const CreatePackageBookingUseCase(this._repository);

  Future<({PtPackageBookingResponseEntity? data, Failure? failure})> call({
    required int packageId,
    required List<Map<String, dynamic>> weeklySchedule,
    String? paymentMethod,
  }) {
    return _repository.createPackageBooking(
      packageId: packageId,
      weeklySchedule: weeklySchedule,
      paymentMethod: paymentMethod,
    );
  }
}
