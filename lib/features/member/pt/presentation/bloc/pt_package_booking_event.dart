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

  const PtPackageBookingStarted({
    required this.trainerId,
    required this.packages,
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

/// Fired when user taps confirm booking.
class PtPackageBookingConfirmRequested extends PtPackageBookingEvent {
  const PtPackageBookingConfirmRequested();
}