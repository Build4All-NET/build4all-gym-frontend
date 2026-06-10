import '../../domain/entities/pt_package_entity.dart';

/// Base class for all PT package booking events.
abstract class PtPackageBookingEvent {
  const PtPackageBookingEvent();
}

/// Fired when the package booking UI starts.
///
/// This event is dispatched after trainer detail is loaded.
///
/// We need trainerId because the package booking flow now loads
/// trainer availability per selected weekday:
///
/// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
class PtPackageBookingStarted extends PtPackageBookingEvent {
  final int trainerId;
  final List<PtPackageEntity> packages;

  // Weekday codes where trainer has set availability.
  final List<String> availableDays;

  const PtPackageBookingStarted({
    required this.trainerId,
    required this.packages,
    this.availableDays = const [],
  });
}

/// Fired when user selects a package card.
///
/// When package changes, selected days/times should reset because
/// each package can have different min/max days per week.
class PtPackageSelected extends PtPackageBookingEvent {
  final PtPackageEntity package;

  const PtPackageSelected(this.package);
}

/// Fired when user selects/unselects a stable weekday.
///
/// No date.
/// No translated label.
///
/// Backend/internal values only:
/// MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY.
class PtPackageDayToggled extends PtPackageBookingEvent {
  final String day;

  const PtPackageDayToggled({
    required this.day,
  });
}

/// Fired internally/after selecting a day to load real PT availability
/// for that weekday.
///
/// Example:
/// day = MONDAY
///
/// Calls:
/// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
class PtPackageWeeklySlotsRequested extends PtPackageBookingEvent {
  final String day;

  const PtPackageWeeklySlotsRequested({
    required this.day,
  });
}

/// Fired when user selects a time for a specific selected weekday.
///
/// Example:
/// day = MONDAY
/// time = 09:00
class PtPackageTimeSelected extends PtPackageBookingEvent {
  final String day;
  final String time;

  const PtPackageTimeSelected({
    required this.day,
    required this.time,
  });
}

/// Fired when user taps confirm booking (no payment yet — opens payment sheet).
class PtPackageBookingConfirmRequested extends PtPackageBookingEvent {
  const PtPackageBookingConfirmRequested();
}

/// Fired by the payment sheet once the user picks a payment method.
///
/// The bloc creates the booking with the chosen paymentMethod and emits
/// PtPackageBookingPaymentReady so the sheet can drive Stripe or redirect.
class PtPackagePaymentConfirmRequested extends PtPackageBookingEvent {
  final String paymentMethod;

  const PtPackagePaymentConfirmRequested(this.paymentMethod);
}

/// Fired by the payment sheet after Stripe presentPaymentSheet() succeeds,
/// or after a redirect payment is confirmed in-browser.
class PtPackagePaymentActivated extends PtPackageBookingEvent {
  const PtPackagePaymentActivated();
}

/// Fired when user requests a custom time from the trainer.
///
/// Used when:
/// - The selected day has no available slots.
/// - The user wants a time outside the trainer's current availability.
///
/// This creates a REQUESTED pt_session (not a confirmed booking).
/// Backend endpoint: POST /api/pt-sessions/request
///
/// hour/minute represent the user's desired start time (24h).
class PtPackageTimeRequestSubmitted extends PtPackageBookingEvent {
  final String day;   // "MONDAY", "TUESDAY", etc.
  final int hour;     // 0-23
  final int minute;   // 0-59

  const PtPackageTimeRequestSubmitted({
    required this.day,
    required this.hour,
    required this.minute,
  });
}