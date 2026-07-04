import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_package_booking_usecase.dart';
import '../../domain/usecases/confirm_package_payment_usecase.dart';
import '../../domain/usecases/check_package_payment_status_usecase.dart';
import '../../domain/usecases/get_weekly_available_slots_usecase.dart';
import '../../domain/usecases/request_booking_usecase.dart';

import 'pt_package_booking_event.dart';
import 'pt_package_booking_state.dart';
import '../../domain/entities/time_slot_entity.dart';

class PtPackageBookingBloc
    extends Bloc<PtPackageBookingEvent, PtPackageBookingState> {
  final CreatePackageBookingUseCase _createPackageBookingUseCase;
  final ConfirmPackagePaymentUseCase _confirmPackagePaymentUseCase;
  final CheckPackagePaymentStatusUseCase _checkPackagePaymentStatusUseCase;
  final GetWeeklyAvailableSlotsUseCase _getWeeklyAvailableSlotsUseCase;
  final RequestBookingUseCase _requestBookingUseCase;

  PtPackageBookingBloc({
    required CreatePackageBookingUseCase createPackageBookingUseCase,
    required ConfirmPackagePaymentUseCase confirmPackagePaymentUseCase,
    required CheckPackagePaymentStatusUseCase checkPackagePaymentStatusUseCase,
    required GetWeeklyAvailableSlotsUseCase getWeeklyAvailableSlotsUseCase,
    required RequestBookingUseCase requestBookingUseCase,
  })  : _createPackageBookingUseCase = createPackageBookingUseCase,
        _confirmPackagePaymentUseCase = confirmPackagePaymentUseCase,
        _checkPackagePaymentStatusUseCase =
            checkPackagePaymentStatusUseCase,
        _getWeeklyAvailableSlotsUseCase =
            getWeeklyAvailableSlotsUseCase,
        _requestBookingUseCase = requestBookingUseCase,
        super(const PtPackageBookingInitial()) {
    on<PtPackageBookingStarted>(_onStarted);
    on<PtPackageSelected>(_onPackageSelected);
    on<PtPackageDayToggled>(_onDayToggled);
    on<PtPackageWeeklySlotsRequested>(_onWeeklySlotsRequested);
    on<PtPackageTimeSelected>(_onTimeSelected);
    on<PtPackageBookingConfirmRequested>(_onConfirmRequested);
    on<PtPackagePaymentConfirmRequested>(_onPaymentConfirmRequested);
    on<PtPackagePaymentActivated>(_onPaymentActivated);
    on<PtPackageTimeRequestSubmitted>(_onTimeRequestSubmitted);
  }

  void _onStarted(
      PtPackageBookingStarted event,
      Emitter<PtPackageBookingState> emit,
      ) {
    emit(
      PtPackageBookingLoaded(
        trainerId: event.trainerId,
        packages: event.packages,
        selectedPackage:
        event.packages.isNotEmpty ? event.packages.first : null,
        availableDays: event.availableDays,
        weeklySchedule: const [],
        weeklySlotsByDay: const {},
        loadingSlotDays: const {},
        slotErrorsByDay: const {},
      ),
    );
  }

  void _onPackageSelected(
      PtPackageSelected event,
      Emitter<PtPackageBookingState> emit,
      ) {
    final current = state;

    if (current is! PtPackageBookingLoaded) return;

    emit(
      current.copyWith(
        selectedPackage: event.package,
        weeklySchedule: const [],
        weeklySlotsByDay: const {},
        loadingSlotDays: const {},
        slotErrorsByDay: const {},
      ),
    );
  }

  void _onDayToggled(
      PtPackageDayToggled event,
      Emitter<PtPackageBookingState> emit,
      ) {
    final current = state;

    if (current is! PtPackageBookingLoaded) return;

    final selectedPackage = current.selectedPackage;

    if (selectedPackage == null) return;

    final day = event.day.trim().toUpperCase();

    if (!_isValidWeekday(day)) return;

    final updatedSchedule = List<Map<String, dynamic>>.from(
      current.weeklySchedule.map(
            (item) => Map<String, dynamic>.from(item),
      ),
    );

    final updatedSlotsByDay =
    Map<String, List<TimeSlotEntity>>.from(
      current.weeklySlotsByDay,
    );

    final updatedLoadingDays =
    Set<String>.from(current.loadingSlotDays);

    final updatedErrorsByDay =
    Map<String, String>.from(current.slotErrorsByDay);

    final existingIndex = updatedSchedule.indexWhere(
          (item) =>
      item['day']?.toString().toUpperCase() == day,
    );

    if (existingIndex != -1) {
      updatedSchedule.removeAt(existingIndex);
      updatedSlotsByDay.remove(day);
      updatedLoadingDays.remove(day);
      updatedErrorsByDay.remove(day);

      emit(
        current.copyWith(
          weeklySchedule: updatedSchedule,
          weeklySlotsByDay: updatedSlotsByDay,
          loadingSlotDays: updatedLoadingDays,
          slotErrorsByDay: updatedErrorsByDay,
        ),
      );

      return;
    }

    if (updatedSchedule.length >=
        selectedPackage.maxDaysPerWeek) {
      return;
    }

    updatedSchedule.add({
      'day': day,
      'time': '',
    });

    emit(
      current.copyWith(
        weeklySchedule: updatedSchedule,
        slotErrorsByDay: updatedErrorsByDay,
      ),
    );

    add(
      PtPackageWeeklySlotsRequested(day: day),
    );
  }

  Future<void> _onWeeklySlotsRequested(
      PtPackageWeeklySlotsRequested event,
      Emitter<PtPackageBookingState> emit,
      ) async {
    final current = state;

    if (current is! PtPackageBookingLoaded) return;

    final day = event.day.trim().toUpperCase();

    if (!_isValidWeekday(day)) return;
    if (!current.isDaySelected(day)) return;

    final loadingDays =
    Set<String>.from(current.loadingSlotDays)..add(day);

    final errorsByDay =
    Map<String, String>.from(current.slotErrorsByDay)
      ..remove(day);

    emit(
      current.copyWith(
        loadingSlotDays: loadingDays,
        slotErrorsByDay: errorsByDay,
      ),
    );

    final result = await _getWeeklyAvailableSlotsUseCase(
      trainerId: current.trainerId,
      day: day,
      packageId: current.selectedPackage?.id,
    );

    final latest = state;

    if (latest is! PtPackageBookingLoaded) return;
    if (!latest.isDaySelected(day)) return;

    final nextLoadingDays =
    Set<String>.from(latest.loadingSlotDays)..remove(day);

    final nextErrorsByDay =
    Map<String, String>.from(latest.slotErrorsByDay);

    final nextSlotsByDay =
    Map<String, List<TimeSlotEntity>>.from(
      latest.weeklySlotsByDay,
    );

    if (result.failure != null || result.data == null) {
      nextErrorsByDay[day] =
          result.failure?.message ?? 'ptWeeklySlotsFailed';

      nextSlotsByDay[day] = const [];

      emit(
        latest.copyWith(
          weeklySlotsByDay: nextSlotsByDay,
          loadingSlotDays: nextLoadingDays,
          slotErrorsByDay: nextErrorsByDay,
        ),
      );

      return;
    }

    nextErrorsByDay.remove(day);
    nextSlotsByDay[day] = result.data!;

    emit(
      latest.copyWith(
        weeklySlotsByDay: nextSlotsByDay,
        loadingSlotDays: nextLoadingDays,
        slotErrorsByDay: nextErrorsByDay,
      ),
    );
  }

  void _onTimeSelected(
      PtPackageTimeSelected event,
      Emitter<PtPackageBookingState> emit,
      ) {
    final current = state;

    if (current is! PtPackageBookingLoaded) return;

    final day = event.day.trim().toUpperCase();
    final time = event.time.trim();

    if (!_isValidWeekday(day)) return;
    if (time.isEmpty) return;

    final slotsForDay = current.availableSlotsForDay(day);

    final selectedSlot = slotsForDay
        .where(
          (slot) => _formatSlotTime(slot) == time,
    )
        .cast<TimeSlotEntity?>()
        .firstWhere(
          (slot) => slot != null,
      orElse: () => null,
    );

    if (selectedSlot == null) return;
    if (!selectedSlot.available || selectedSlot.full) return;

    final updatedSchedule =
    List<Map<String, dynamic>>.from(
      current.weeklySchedule.map(
            (item) => Map<String, dynamic>.from(item),
      ),
    );

    final existingIndex = updatedSchedule.indexWhere(
          (item) =>
      item['day']?.toString().toUpperCase() == day,
    );

    if (existingIndex == -1) return;

    updatedSchedule[existingIndex] = {
      ...updatedSchedule[existingIndex],
      'day': day,
      'time': time,
    };

    emit(
      current.copyWith(
        weeklySchedule: updatedSchedule,
      ),
    );
  }

  void _onConfirmRequested(
      PtPackageBookingConfirmRequested event,
      Emitter<PtPackageBookingState> emit,
      ) {
    /*
     * No operation here.
     *
     * The confirmation bar opens the payment sheet directly.
     * The payment sheet dispatches PtPackagePaymentConfirmRequested.
     */
  }

  Future<void> _onPaymentConfirmRequested(
      PtPackagePaymentConfirmRequested event,
      Emitter<PtPackageBookingState> emit,
      ) async {
    final current = state;

    if (current is! PtPackageBookingLoaded ||
        !current.canConfirm) {
      return;
    }

    final selectedPackage = current.selectedPackage!;

    /*
     * Extra protection.
     * Do not create another booking for a package that is already
     * pending, active, booked or awaiting cancellation.
     */
    if (selectedPackage.isBookingDisabled) {
      return;
    }

    emit(
      PtPackageBookingSubmitting(
        trainerId: current.trainerId,
        packages: current.packages,
        selectedPackage: current.selectedPackage,
        availableDays: current.availableDays,
        weeklySchedule: current.weeklySchedule,
        weeklySlotsByDay: current.weeklySlotsByDay,
        loadingSlotDays: current.loadingSlotDays,
        slotErrorsByDay: current.slotErrorsByDay,
      ),
    );

    final result = await _createPackageBookingUseCase(
      packageId: selectedPackage.id,
      weeklySchedule: current.weeklySchedule,
      paymentMethod: event.paymentMethod,
    );

    if (result.failure != null || result.data == null) {
      emit(
        PtPackageBookingError(
          trainerId: current.trainerId,
          packages: current.packages,
          selectedPackage: current.selectedPackage,
          availableDays: current.availableDays,
          weeklySchedule: current.weeklySchedule,
          weeklySlotsByDay: current.weeklySlotsByDay,
          loadingSlotDays: current.loadingSlotDays,
          slotErrorsByDay: current.slotErrorsByDay,
          message:
          result.failure?.message ??
              'ptPackageBookingFailed',
        ),
      );

      return;
    }

    final booking = result.data!;

    /*
     * Cash booking:
     *
     * The backend creates the booking as PENDING.
     * Update only the selected package locally.
     *
     * Other packages stay unchanged and can still be booked
     * unless the backend business rules prevent it.
     */
    if (!booking.isStripe && !booking.isRedirect) {
      final updatedSelectedPackage =
      selectedPackage.copyWith(
        bookingStatus: 'PENDING',
      );

      final updatedPackages =
      current.packages.map((package) {
        if (package.id == selectedPackage.id) {
          return updatedSelectedPackage;
        }

        return package;
      }).toList();

      emit(
        PtPackageBookingSuccess(
          trainerId: current.trainerId,
          packages: updatedPackages,
          selectedPackage: updatedSelectedPackage,
          availableDays: current.availableDays,
          weeklySchedule: current.weeklySchedule,
          weeklySlotsByDay: current.weeklySlotsByDay,
          loadingSlotDays: current.loadingSlotDays,
          slotErrorsByDay: current.slotErrorsByDay,
          booking: booking,
        ),
      );

      return;
    }

    /*
     * Stripe or redirect payment.
     * The payment sheet completes the external payment flow.
     */
    emit(
      PtPackageBookingPaymentReady(
        trainerId: current.trainerId,
        packages: current.packages,
        selectedPackage: current.selectedPackage,
        availableDays: current.availableDays,
        weeklySchedule: current.weeklySchedule,
        weeklySlotsByDay: current.weeklySlotsByDay,
        loadingSlotDays: current.loadingSlotDays,
        slotErrorsByDay: current.slotErrorsByDay,
        booking: booking,
      ),
    );
  }

  Future<void> _onPaymentActivated(
      PtPackagePaymentActivated event,
      Emitter<PtPackageBookingState> emit,
      ) async {
    final current = state;

    if (current is! PtPackageBookingPaymentReady) return;

    final bookingId = current.booking.id;
    final isRedirect = current.booking.isRedirect;

    final result = isRedirect
        ? await _checkPackagePaymentStatusUseCase(
      bookingId,
    )
        : await _confirmPackagePaymentUseCase(
      bookingId,
    );

    if (result.failure != null || result.data == null) {
      emit(
        PtPackageBookingError(
          trainerId: current.trainerId,
          packages: current.packages,
          selectedPackage: current.selectedPackage,
          availableDays: current.availableDays,
          weeklySchedule: current.weeklySchedule,
          weeklySlotsByDay: current.weeklySlotsByDay,
          loadingSlotDays: current.loadingSlotDays,
          slotErrorsByDay: current.slotErrorsByDay,
          message:
          result.failure?.message ??
              'ptPackageBookingFailed',
        ),
      );

      return;
    }

    final selectedPackage = current.selectedPackage;

    /*
     * Online payment completed successfully.
     * Update the selected package locally to ACTIVE.
     */
    final updatedSelectedPackage =
    selectedPackage?.copyWith(
      bookingStatus: 'ACTIVE',
    );

    final updatedPackages =
    current.packages.map((package) {
      if (updatedSelectedPackage != null &&
          package.id == updatedSelectedPackage.id) {
        return updatedSelectedPackage;
      }

      return package;
    }).toList();

    emit(
      PtPackageBookingSuccess(
        trainerId: current.trainerId,
        packages: updatedPackages,
        selectedPackage: updatedSelectedPackage,
        availableDays: current.availableDays,
        weeklySchedule: current.weeklySchedule,
        weeklySlotsByDay: current.weeklySlotsByDay,
        loadingSlotDays: current.loadingSlotDays,
        slotErrorsByDay: current.slotErrorsByDay,
        booking: result.data!,
      ),
    );
  }

  Future<void> _onTimeRequestSubmitted(
      PtPackageTimeRequestSubmitted event,
      Emitter<PtPackageBookingState> emit,
      ) async {
    final current = state;

    if (current is! PtPackageBookingLoaded) return;

    final day = event.day.trim().toUpperCase();

    if (!_isValidWeekday(day)) return;

    emit(
      current.copyWith(
        requestingDay: day,
      ),
    );

    final date = _nextOccurrenceOf(day);

    final startDt = DateTime(
      date.year,
      date.month,
      date.day,
      event.hour,
      event.minute,
    );

    final durationMinutes =
        current.selectedPackage?.sessionDurationMinutes ??
            60;

    final endDt = startDt.add(
      Duration(minutes: durationMinutes),
    );

    final result = await _requestBookingUseCase(
      trainerId: current.trainerId,
      startTime: _toIso(startDt),
      endTime: _toIso(endDt),
    );

    final latest = state;

    if (latest is! PtPackageBookingLoaded) return;

    if (result.failure != null || result.data == null) {
      emit(
        PtPackageTimeRequestError(
          trainerId: latest.trainerId,
          packages: latest.packages,
          selectedPackage: latest.selectedPackage,
          availableDays: latest.availableDays,
          weeklySchedule: latest.weeklySchedule,
          weeklySlotsByDay: latest.weeklySlotsByDay,
          loadingSlotDays: latest.loadingSlotDays,
          slotErrorsByDay: latest.slotErrorsByDay,
          message:
          result.failure?.message ??
              'ptRequestTimeFailed',
        ),
      );

      return;
    }

    emit(
      PtPackageTimeRequestSuccess(
        trainerId: latest.trainerId,
        packages: latest.packages,
        selectedPackage: latest.selectedPackage,
        availableDays: latest.availableDays,
        weeklySchedule: latest.weeklySchedule,
        weeklySlotsByDay: latest.weeklySlotsByDay,
        loadingSlotDays: latest.loadingSlotDays,
        slotErrorsByDay: latest.slotErrorsByDay,
        requestedDay: day,
      ),
    );
  }

  DateTime _nextOccurrenceOf(String day) {
    const codes = {
      'MONDAY': 1,
      'TUESDAY': 2,
      'WEDNESDAY': 3,
      'THURSDAY': 4,
      'FRIDAY': 5,
      'SATURDAY': 6,
      'SUNDAY': 7,
    };

    final target = codes[day] ?? 1;
    final now = DateTime.now();

    var daysAhead = target - now.weekday;

    if (daysAhead <= 0) {
      daysAhead += 7;
    }

    return now.add(
      Duration(days: daysAhead),
    );
  }

  String _toIso(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}T'
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:00';
  }

  String _formatSlotTime(TimeSlotEntity slot) {
    final rawStartTime = slot.startTime.toString();

    try {
      final parsed = DateTime.parse(rawStartTime);

      return '${parsed.hour.toString().padLeft(2, '0')}:'
          '${parsed.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      if (rawStartTime.length >= 5) {
        return rawStartTime.substring(0, 5);
      }

      return rawStartTime;
    }
  }

  bool _isValidWeekday(String day) {
    return const {
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    }.contains(day);
  }
}