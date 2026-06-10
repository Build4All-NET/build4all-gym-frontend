import '../../domain/entities/member_booking_entity.dart';

/*
 * Events for My Bookings screen.
 */
abstract class MemberBookingsEvent {
  const MemberBookingsEvent();
}

/*
 * First load.
 */
class MemberBookingsStarted extends MemberBookingsEvent {
  const MemberBookingsStarted();
}

/*
 * User switches tab:
 * - UPCOMING
 * - PREVIOUS
 */
class MemberBookingsTabChanged extends MemberBookingsEvent {
  final String tab;

  const MemberBookingsTabChanged(this.tab);
}

/*
 * Pull-to-refresh or manual reload.
 */
class MemberBookingsRefreshRequested extends MemberBookingsEvent {
  const MemberBookingsRefreshRequested();
}

/*
 * User clicks cancel button on a booking card.
 */
class MemberBookingCancelRequested extends MemberBookingsEvent {
  final MemberBookingEntity booking;

  const MemberBookingCancelRequested(this.booking);
}
/*
 * User submits rating/review for a completed booking.
 */
class MemberBookingReviewSubmitted extends MemberBookingsEvent {
  final MemberBookingEntity booking;
  final int rating;
  final String? comment;

  const MemberBookingReviewSubmitted({
    required this.booking,
    required this.rating,
    this.comment,
  });
}