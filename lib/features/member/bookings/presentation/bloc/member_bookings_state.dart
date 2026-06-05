import '../../domain/entities/member_booking_entity.dart';

/*
 * States for My Bookings screen.
 */
abstract class MemberBookingsState {
  const MemberBookingsState();
}

class MemberBookingsInitial extends MemberBookingsState {
  const MemberBookingsInitial();
}

class MemberBookingsLoading extends MemberBookingsState {
  final String tab;

  const MemberBookingsLoading({
    required this.tab,
  });
}

class MemberBookingsLoaded extends MemberBookingsState {
  final List<MemberBookingEntity> bookings;
  final String tab;

  /*
   * Optional key used by UI to show snackbar after actions.
   * The actual message comes from ARB.
   */
  final String? messageKey;

  const MemberBookingsLoaded({
    required this.bookings,
    required this.tab,
    this.messageKey,
  });
}

/*
 * Keeps current list visible while cancel request is being sent.
 */
class MemberBookingsActionLoading extends MemberBookingsState {
  final List<MemberBookingEntity> bookings;
  final String tab;

  const MemberBookingsActionLoading({
    required this.bookings,
    required this.tab,
  });
}

class MemberBookingsError extends MemberBookingsState {
  final String tab;
  final String messageKey;

  const MemberBookingsError({
    required this.tab,
    required this.messageKey,
  });
}