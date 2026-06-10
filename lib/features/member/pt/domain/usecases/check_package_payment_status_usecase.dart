import '../../../../../core/error/failures.dart';
import '../entities/pt_package_booking_response_entity.dart';
import '../repositories/member_pt_repository.dart';

class CheckPackagePaymentStatusUseCase {
  final MemberPtRepository _repository;

  const CheckPackagePaymentStatusUseCase(this._repository);

  Future<({PtPackageBookingResponseEntity? data, Failure? failure})> call(
    int bookingId,
  ) {
    return _repository.checkPackagePaymentStatus(bookingId);
  }
}
