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
 * User requests cancellation for a booking.
 *
 * For PT sessions:
 * - requestedNewDate = null  → pure cancel
 * - requestedNewDate != null → cancel + reschedule proposal
 *
 * For CLASS bookings, requestedNewDate is always ignored.
 */
class MemberBookingCancelRequested extends MemberBookingsEvent {
  final MemberBookingEntity booking;
  final DateTime? requestedNewDate;

  const MemberBookingCancelRequested(this.booking, {this.requestedNewDate});
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