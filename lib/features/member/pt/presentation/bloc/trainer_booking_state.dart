import '../../domain/entities/pt_booking_response_entity.dart';
import '../../domain/entities/time_slot_entity.dart';

/// Base class for all booking states.
abstract class TrainerBookingState {
  const TrainerBookingState();
}

/// Initial empty state before the screen sends TrainerBookingStarted.
class TrainerBookingInitial extends TrainerBookingState {
  const TrainerBookingInitial();
}

/// Main state used when the booking screen has loaded.
///
/// It keeps:
/// - trainerId
/// - selectedDate
/// - selectedSlot
///
/// The button should be enabled only when selectedDate and selectedSlot exist.
class TrainerBookingLoaded extends TrainerBookingState {
  final int trainerId;
  final DateTime? selectedDate;
  final TimeSlotEntity? selectedSlot;

  const TrainerBookingLoaded({
    required this.trainerId,
    this.selectedDate,
    this.selectedSlot,
  });

  /// True only when user selected both required booking inputs.
  bool get canConfirm => selectedDate != null && selectedSlot != null;

  /// True when selected slot can be booked directly.
  ///
  /// Normal booking should use:
  /// POST /api/pt-sessions
  bool get canBookNormally {
    final slot = selectedSlot;

    if (selectedDate == null || slot == null) {
      return false;
    }

    return slot.available && !slot.full;
  }

  /// True when selected slot cannot be booked directly,
  /// but user can send request to PT.
  ///
  /// Request booking should use:
  /// POST /api/pt-sessions/request
  bool get canRequest {
    final slot = selectedSlot;

    if (selectedDate == null || slot == null) {
      return false;
    }

    return !slot.available || slot.full;
  }

  /// Creates a new state while keeping old values by default.
  ///
  /// clearSelectedDate / clearSelectedSlot are needed because normal copyWith
  /// cannot distinguish between:
  /// - "do not change this value"
  /// - "set this value to null"
  TrainerBookingLoaded copyWith({
    int? trainerId,
    DateTime? selectedDate,
    TimeSlotEntity? selectedSlot,
    bool clearSelectedDate = false,
    bool clearSelectedSlot = false,
  }) {
    return TrainerBookingLoaded(
      trainerId: trainerId ?? this.trainerId,
      selectedDate: clearSelectedDate ? null : selectedDate ?? this.selectedDate,
      selectedSlot: clearSelectedSlot ? null : selectedSlot ?? this.selectedSlot,
    );
  }
}

/// State emitted while a booking/request API call is running.
///
/// The UI listens to this state and shows CircularProgressIndicator.
class TrainerBookingSubmitting extends TrainerBookingLoaded {
  const TrainerBookingSubmitting({
    required super.trainerId,
    required super.selectedDate,
    required super.selectedSlot,
  });
}

/// Compatibility state.
///
/// Your old Bloc used TrainerBookingConfirmed as the loading state.
/// Keep this class so older UI checks do not break.
/// New code should prefer TrainerBookingSubmitting.
class TrainerBookingConfirmed extends TrainerBookingSubmitting {
  const TrainerBookingConfirmed({
    required super.trainerId,
    required super.selectedDate,
    required super.selectedSlot,
  });
}

/// State emitted when the normal booking API succeeds.
///
/// Backend status:
/// SCHEDULED
///
/// The UI listens to this state and:
/// - pops the screen
/// - shows success SnackBar
class TrainerBookingSuccess extends TrainerBookingLoaded {
  final PtBookingResponseEntity booking;

  const TrainerBookingSuccess({
    required super.trainerId,
    required super.selectedDate,
    required super.selectedSlot,
    required this.booking,
  });
}

/// State emitted when the request booking API succeeds.
///
/// Backend status:
/// REQUESTED
///
/// The UI listens to this state and:
/// - keeps or pops the screen depending on UX
/// - shows "Request sent to PT" SnackBar
class TrainerBookingRequestSuccess extends TrainerBookingLoaded {
  final PtBookingResponseEntity booking;

  const TrainerBookingRequestSuccess({
    required super.trainerId,
    required super.selectedDate,
    required super.selectedSlot,
    required this.booking,
  });
}

/// State emitted when the booking/request API fails.
///
/// The UI listens to this state and:
/// - shows error SnackBar
/// - keeps screen open
class TrainerBookingError extends TrainerBookingLoaded {
  final String message;

  const TrainerBookingError({
    required super.trainerId,
    required super.selectedDate,
    required super.selectedSlot,
    required this.message,
  });
}