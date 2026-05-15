import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_booking_usecase.dart';
import 'trainer_booking_event.dart';
import 'trainer_booking_state.dart';

/// Bloc responsible for confirming a PT trainer booking.
///
/// It does NOT handle loading trainer details or available slots.
/// It only manages:
/// - selected date
/// - selected slot
/// - confirm booking request
/// - booking success/error
class TrainerBookingBloc
    extends Bloc<TrainerBookingEvent, TrainerBookingState> {
  final CreateBookingUseCase _createBookingUseCase;

  TrainerBookingBloc({
    required CreateBookingUseCase createBookingUseCase,
  })  : _createBookingUseCase = createBookingUseCase,
        super(const TrainerBookingInitial()) {
    on<TrainerBookingStarted>(_onStarted);
    on<TrainerBookingSelectionChanged>(_onSelectionChanged);
    on<TrainerBookingConfirmRequested>(_onConfirmRequested);
  }

  /// Initializes the booking state when the screen/bar is created.
  void _onStarted(
      TrainerBookingStarted event,
      Emitter<TrainerBookingState> emit,
      ) {
    emit(
      TrainerBookingLoaded(
        trainerId: event.trainerId,
        selectedDate: event.selectedDate,
        selectedSlot: event.selectedSlot,
      ),
    );
  }

  /// Updates selected date/slot whenever the user changes selection.
  void _onSelectionChanged(
      TrainerBookingSelectionChanged event,
      Emitter<TrainerBookingState> emit,
      ) {
    final current = state;

    // Ignore this event if the Bloc has not been initialized yet.
    if (current is! TrainerBookingLoaded) return;

    emit(
      current.copyWith(
        selectedDate: event.selectedDate,
        selectedSlot: event.selectedSlot,

        // Allows setting values back to null.
        clearSelectedDate: event.selectedDate == null,
        clearSelectedSlot: event.selectedSlot == null,
      ),
    );
  }

  /// Called when user taps "تأكيد الحجز".
  Future<void> _onConfirmRequested(
      TrainerBookingConfirmRequested event,
      Emitter<TrainerBookingState> emit,
      ) async {
    final current = state;

    // Safety checks:
    // - state must be loaded
    // - date and slot must be selected
    // - avoid duplicate request while already confirming
    if (current is! TrainerBookingLoaded || !current.canConfirm) return;
    if (current is TrainerBookingConfirmed) return;

    final selectedDate = current.selectedDate!;
    final selectedSlot = current.selectedSlot!;

    // Tell UI to show loading spinner.
    emit(
      TrainerBookingConfirmed(
        trainerId: current.trainerId,
        selectedDate: selectedDate,
        selectedSlot: selectedSlot,
      ),
    );

    // Call domain usecase.
    // This eventually calls POST /api/pt-services.
    final result = await _createBookingUseCase(
      trainerId: current.trainerId,
      startTime: _normalizeSlotDateTime(selectedDate, selectedSlot.startTime),
      endTime: _normalizeSlotDateTime(selectedDate, selectedSlot.endTime),
    );

    // API failed.
    if (result.failure != null || result.data == null) {
      emit(
        TrainerBookingError(
          trainerId: current.trainerId,
          selectedDate: selectedDate,
          selectedSlot: selectedSlot,
          message: result.failure?.message ?? 'تعذر تأكيد الحجز.',
        ),
      );
      return;
    }

    // API succeeded.
    emit(
      TrainerBookingSuccess(
        trainerId: current.trainerId,
        selectedDate: selectedDate,
        selectedSlot: selectedSlot,
        booking: result.data!,
      ),
    );
  }

  /// Converts slot time into a backend-friendly ISO date-time string.
  ///
  /// Supports two cases:
  ///
  /// 1. Backend already gave full DateTime:
  ///    "2026-05-08T14:00:00.000Z"
  ///
  /// 2. Backend/UI only gave time:
  ///    "14:00"
  ///
  /// In case 2, we combine selectedDate + slot time.
  static String _normalizeSlotDateTime(DateTime selectedDate, String value) {
    final parsed = DateTime.tryParse(value);

    // If value is already a valid DateTime string, use it directly.
    if (parsed != null) {
      return parsed.toIso8601String();
    }

    final raw = value.trim();
    final parts = raw.split(':');

    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    ).toIso8601String();
  }
}