import '../entities/member_booking_entity.dart';

/*
 * Domain contract for member bookings.
 *
 * Presentation layer depends on this abstraction,
 * not directly on Dio or service classes.
 */
abstract class MemberBookingsRepository {
  Future<List<MemberBookingEntity>> getBookings({
    required String tab,
  });

  Future<void> requestClassCancel(int bookingId);

  Future<void> requestPtCancel(int ptSessionId);
  Future<void> submitClassReview({
    required int bookingId,
    required int rating,
    String? comment,
  });

  Future<void> submitPtReview({
    required int ptSessionId,
    required int rating,
    String? comment,
  });
}