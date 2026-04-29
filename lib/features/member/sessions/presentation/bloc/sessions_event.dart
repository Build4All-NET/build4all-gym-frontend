abstract class SessionsEvent {
  const SessionsEvent();
}

class SessionsStarted extends SessionsEvent {
  const SessionsStarted();
}

class SessionsDateChanged extends SessionsEvent {
  final DateTime date;

  const SessionsDateChanged(this.date);
}

class SessionsFilterApplied extends SessionsEvent {
  final int? classTypeId;
  final int? trainerId;
  final String? branchId;

  const SessionsFilterApplied({
    this.classTypeId,
    this.trainerId,
    this.branchId,
  });
}

class SessionsFilterReset extends SessionsEvent {
  const SessionsFilterReset();
}

class SessionBookRequested extends SessionsEvent {
  final int sessionId;

  const SessionBookRequested(this.sessionId);
}

class SessionBookingCancelRequested extends SessionsEvent {
  final int bookingId;

  const SessionBookingCancelRequested(this.bookingId);
}
class SessionsFilterOptionsRequested extends SessionsEvent {
  const SessionsFilterOptionsRequested();
}