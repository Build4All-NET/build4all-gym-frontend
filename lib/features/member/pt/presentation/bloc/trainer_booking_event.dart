import '../../domain/entities/time_slot_entity.dart';

/// Base class for all booking events.
abstract class TrainerBookingEvent {
  const TrainerBookingEvent();
}

/// Fired when the booking screen/bar is initialized.
///
/// This stores the trainer ID and the first selected date/slot values.
/// Usually date and slot are null at the beginning.
class TrainerBookingStarted extends TrainerBookingEvent {
  final int trainerId;
  final DateTime? selectedDate;
  final TimeSlotEntity? selectedSlot;

  const TrainerBookingStarted({
    required this.trainerId,
    this.selectedDate,
    this.selectedSlot,
  });
}

/// Fired whenever the user changes the selected date or selected time slot.
///
/// Example:
/// - user selects date => selectedDate updated
/// - user selects time => selectedSlot updated
/// - user clears date/slot => one of them becomes null
class TrainerBookingSelectionChanged extends TrainerBookingEvent {
  final DateTime? selectedDate;
  final TimeSlotEntity? selectedSlot;

  const TrainerBookingSelectionChanged({
    required this.selectedDate,
    required this.selectedSlot,
  });
}

/// Fired when the user taps normal booking confirm.
///
/// This should be used only when the selected slot is available
/// and not full.
class TrainerBookingConfirmRequested extends TrainerBookingEvent {
  const TrainerBookingConfirmRequested();
}

/// Fired when the user taps "Request this time".
///
/// Used when:
/// - selected slot is full
/// - selected slot is unavailable
/// - member still wants to ask the PT
///
/// Backend will create a REQUESTED session,
/// not a confirmed SCHEDULED session.
class TrainerBookingRequestRequested extends TrainerBookingEvent {
  final String? notes;

  const TrainerBookingRequestRequested({
    this.notes,
  });
}