import '../entities/member_booking_entity.dart';
import '../repositories/member_bookings_repository.dart';

/*
 * Use case for cancel request.
 *
 * It decides which endpoint to call based on bookingType:
 * - CLASS => /class/{bookingId}/cancel-request
 * - PT    => /pt/{ptSessionId}/cancel-request
 */
class RequestMemberBookingCancelUseCase {
  final MemberBookingsRepository repository;

  RequestMemberBookingCancelUseCase(this.repository);

  Future<void> call(MemberBookingEntity booking) {
    if (booking.isClass) {
      return repository.requestClassCancel(booking.bookingId);
    }

    return repository.requestPtCancel(booking.effectivePtSessionId);
  }
}