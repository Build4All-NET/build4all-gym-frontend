import '../entities/member_booking_entity.dart';
import '../repositories/member_bookings_repository.dart';

/*
 * Use case for submitting a rating/review.
 *
 * It chooses the correct backend endpoint based on booking type:
 * - CLASS => class review
 * - PT    => trainer/PT session review
 */
class SubmitMemberBookingReviewUseCase {
  final MemberBookingsRepository repository;

  SubmitMemberBookingReviewUseCase(this.repository);

  Future<void> call({
    required MemberBookingEntity booking,
    required int rating,
    String? comment,
  }) {
    if (booking.isClass) {
      return repository.submitClassReview(
        bookingId: booking.bookingId,
        rating: rating,
        comment: comment,
      );
    }

    return repository.submitPtReview(
      ptSessionId: booking.effectivePtSessionId,
      rating: rating,
      comment: comment,
    );
  }
}