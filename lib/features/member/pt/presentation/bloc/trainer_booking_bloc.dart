import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/request_booking_usecase.dart';

import 'trainer_booking_event.dart';
import 'trainer_booking_state.dart';

/// Bloc responsible for confirming or requesting a PT trainer booking.
///
/// It manages:
/// - selected date
/// - selected slot
/// - normal confirmed booking
/// - request booking for full/unavailable time
/// - booking success/error
class TrainerBookingBloc
    extends Bloc<TrainerBookingEvent, TrainerBookingState> {
  final CreateBookingUseCase _createBookingUseCase;
  final RequestBookingUseCase _requestBookingUseCase;

  TrainerBookingBloc({
    required CreateBookingUseCase createBookingUseCase,
    required RequestBookingUseCase requestBookingUseCase,
  })  : _createBookingUseCase = createBookingUseCase,
        _requestBookingUseCase = requestBookingUseCase,
        super(const TrainerBookingInitial()) {
    on<TrainerBookingStarted>(_onStarted);
    on<TrainerBookingSelectionChanged>(_onSelectionChanged);
    on<TrainerBookingConfirmRequested>(_onConfirmRequested);
    on<TrainerBookingRequestRequested>(_onRequestRequested);
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

    if (current is! TrainerBookingLoaded) return;

    emit(
      current.copyWith(
        selectedDate: event.selectedDate,
        selectedSlot: event.selectedSlot,
        clearSelectedDate: event.selectedDate == null,
        clearSelectedSlot: event.selectedSlot == null,
      ),
    );
  }

  /// Called when user taps normal confirm booking.
  ///
  /// This should only be used when:
  /// selectedSlot.available == true
  /// selectedSlot.full == false
  Future<void> _onConfirmRequested(
      TrainerBookingConfirmRequested event,
      Emitter<TrainerBookingState> emit,
      ) async {
    final current = state;

    if (current is! TrainerBookingLoaded || !current.canConfirm) return;
    if (current is TrainerBookingSubmitting) return;

    final selectedDate = current.selectedDate!;
    final selectedSlot = current.selectedSlot!;

    /*
     * Do not create a confirmed booking for unavailable/full slot.
     * Those slots must use TrainerBookingRequestRequested instead.
     */
    if (!selectedSlot.available || selectedSlot.full) {
      emit(
        TrainerBookingError(
          trainerId: current.trainerId,
          selectedDate: selectedDate,
          selectedSlot: selectedSlot,
          message: 'This slot is full or unavailable. Send a request instead.',
        ),
      );
      return;
    }

    emit(
      TrainerBookingSubmitting(
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

    emit(
      TrainerBookingSuccess(
        trainerId: current.trainerId,
        selectedDate: selectedDate,
        selectedSlot: selectedSlot,
        booking: result.data!,
      ),
    );
  }

  /// Called when user taps "Request this time".
  ///
  /// This creates REQUESTED session in backend:
  /// POST /api/pt-sessions/request
  Future<void> _onRequestRequested(
      TrainerBookingRequestRequested event,
      Emitter<TrainerBookingState> emit,
      ) async {
    final current = state;

    if (current is! TrainerBookingLoaded || !current.canConfirm) return;
    if (current is TrainerBookingSubmitting) return;

    final selectedDate = current.selectedDate!;
    final selectedSlot = current.selectedSlot!;

    emit(
      TrainerBookingSubmitting(
        trainerId: current.trainerId,
        selectedDate: selectedDate,
        selectedSlot: selectedSlot,
      ),
    );

    final result = await _requestBookingUseCase(
      trainerId: current.trainerId,
      startTime: _normalizeSlotDateTime(selectedDate, selectedSlot.startTime),
      endTime: _normalizeSlotDateTime(selectedDate, selectedSlot.endTime),
      notes: event.notes,
    );

    if (result.failure != null || result.data == null) {
      emit(
        TrainerBookingError(
          trainerId: current.trainerId,
          selectedDate: selectedDate,
          selectedSlot: selectedSlot,
          message: result.failure?.message ?? 'تعذر إرسال الطلب.',
        ),
      );
      return;
    }

    emit(
      TrainerBookingRequestSuccess(
        trainerId: current.trainerId,
        selectedDate: selectedDate,
        selectedSlot: selectedSlot,
        booking: result.data!,
      ),
    );
  }

  /// Converts slot time into a backend-friendly ISO date-time string.
  ///
  /// Supports:
  /// 1. Full DateTime from backend:
  ///    "2026-05-08T14:00:00.000Z"
  ///
  /// 2. Time only:
  ///    "14:00"
  ///
  /// In case 2, combine selectedDate + slot time.
  static String _normalizeSlotDateTime(DateTime selectedDate, String value) {
    final parsed = DateTime.tryParse(value);

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