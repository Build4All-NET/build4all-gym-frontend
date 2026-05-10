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

/// Fired when the user taps "تأكيد الحجز".
///
/// The Bloc will only continue if both date and slot are selected.
class TrainerBookingConfirmRequested extends TrainerBookingEvent {
  const TrainerBookingConfirmRequested();
}