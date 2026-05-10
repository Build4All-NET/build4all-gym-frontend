import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_package_booking_usecase.dart';
import '../../domain/usecases/get_weekly_available_slots_usecase.dart';

import 'pt_package_booking_event.dart';
import 'pt_package_booking_state.dart';

/// Bloc for the PT package booking flow.
///
/// New flow:
/// - trainerId
/// - selectedPackage
/// - weeklySchedule
/// - weeklySlotsByDay
///
/// weeklySchedule example:
/// [
///   {
///     "day": "MONDAY",
///     "time": "09:00"
///   },
///   {
///     "day": "WEDNESDAY",
///     "time": "14:00"
///   }
/// ]
///
/// weeklySlotsByDay example:
/// {
///   "MONDAY": [TimeSlotEntity(...), TimeSlotEntity(...)],
///   "WEDNESDAY": [TimeSlotEntity(...)]
/// }
class PtPackageBookingBloc
    extends Bloc<PtPackageBookingEvent, PtPackageBookingState> {
  final CreatePackageBookingUseCase _createPackageBookingUseCase;
  final GetWeeklyAvailableSlotsUseCase _getWeeklyAvailableSlotsUseCase;

  PtPackageBookingBloc({
    required CreatePackageBookingUseCase createPackageBookingUseCase,
    required GetWeeklyAvailableSlotsUseCase getWeeklyAvailableSlotsUseCase,
  })  : _createPackageBookingUseCase = createPackageBookingUseCase,
        _getWeeklyAvailableSlotsUseCase = getWeeklyAvailableSlotsUseCase,
        super(const PtPackageBookingInitial()) {
    on<PtPackageBookingStarted>(_onStarted);
    on<PtPackageSelected>(_onPackageSelected);
    on<PtPackageDayToggled>(_onDayToggled);
    on<PtPackageWeeklySlotsRequested>(_onWeeklySlotsRequested);
    on<PtPackageTimeSelected>(_onTimeSelected);
    on<PtPackageBookingConfirmRequested>(_onConfirmRequested);
  }

  /// Initializes package booking state after trainer detail has loaded.
  ///
  /// First package is selected by default if packages exist.
  void _onStarted(
      PtPackageBookingStarted event,
      Emitter<PtPackageBookingState> emit,
      ) {
    emit(
      PtPackageBookingLoaded(
        trainerId: event.trainerId,
        packages: event.packages,
        selectedPackage: event.packages.isNotEmpty ? event.packages.first : null,
        weeklySchedule: const [],
        weeklySlotsByDay: const {},
        loadingSlotDays: const {},
        slotErrorsByDay: const {},
      ),
    );
  }

  /// User selected a package.
  ///
  /// Reset weekly schedule and loaded slots because every package can have
  /// different min/max weekly day rules.
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

  /// User toggles a stable weekday.
  ///
  /// Logic:
  /// - If selected: remove it, remove its time, remove its loaded slots.
  /// - If not selected: add it with empty time.
  /// - Stop at package.maxDaysPerWeek.
  /// - After adding a day, request real trainer availability for that day.
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

    final updatedSlotsByDay = Map<String, List<dynamic>>.from(
      current.weeklySlotsByDay,
    ).map(
          (key, value) => MapEntry(
        key,
        current.weeklySlotsByDay[key] ?? const [],
      ),
    );

    final updatedLoadingDays = Set<String>.from(current.loadingSlotDays);
    final updatedErrorsByDay = Map<String, String>.from(current.slotErrorsByDay);

    final existingIndex = updatedSchedule.indexWhere(
          (item) => item['day']?.toString().toUpperCase() == day,
    );

    if (existingIndex != -1) {
      /// Unselect day.
      updatedSchedule.removeAt(existingIndex);
      updatedSlotsByDay.remove(day);
      updatedLoadingDays.remove(day);
      updatedErrorsByDay.remove(day);

      emit(
        current.copyWith(
          weeklySchedule: updatedSchedule,
          weeklySlotsByDay: updatedSlotsByDay.cast(),
          loadingSlotDays: updatedLoadingDays,
          slotErrorsByDay: updatedErrorsByDay,
        ),
      );

      return;
    }

    /// Stop user from selecting more than the package maximum.
    if (updatedSchedule.length >= selectedPackage.maxDaysPerWeek) {
      return;
    }

    /// Add selected day with no time yet.
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

    /// Load real PT availability for this weekday from backend.
    add(
      PtPackageWeeklySlotsRequested(day: day),
    );
  }

  /// Loads real weekly trainer availability for one selected weekday.
  ///
  /// Calls:
  /// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
  Future<void> _onWeeklySlotsRequested(
      PtPackageWeeklySlotsRequested event,
      Emitter<PtPackageBookingState> emit,
      ) async {
    final current = state;

    if (current is! PtPackageBookingLoaded) return;

    final day = event.day.trim().toUpperCase();

    if (!_isValidWeekday(day)) return;
    if (!current.isDaySelected(day)) return;

    /// Mark this day as loading.
    final loadingDays = Set<String>.from(current.loadingSlotDays)..add(day);
    final errorsByDay = Map<String, String>.from(current.slotErrorsByDay)
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
    );

    final latest = state;

    if (latest is! PtPackageBookingLoaded) return;

    /// If user unselected the day while request was running, ignore result.
    if (!latest.isDaySelected(day)) return;

    final nextLoadingDays = Set<String>.from(latest.loadingSlotDays)
      ..remove(day);

    final nextErrorsByDay = Map<String, String>.from(latest.slotErrorsByDay);
    final nextSlotsByDay = Map<String, dynamic>.from(latest.weeklySlotsByDay);

    if (result.failure != null || result.data == null) {
      nextErrorsByDay[day] = result.failure?.message ?? 'ptWeeklySlotsFailed';
      nextSlotsByDay[day] = const [];

      emit(
        latest.copyWith(
          weeklySlotsByDay: nextSlotsByDay.cast(),
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
        weeklySlotsByDay: nextSlotsByDay.cast(),
        loadingSlotDays: nextLoadingDays,
        slotErrorsByDay: nextErrorsByDay,
      ),
    );
  }

  /// User selected a time for a specific weekday.
  ///
  /// Day must already be selected.
  /// Time must come from the available slots UI.
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

    final updatedSchedule = List<Map<String, dynamic>>.from(
      current.weeklySchedule.map(
            (item) => Map<String, dynamic>.from(item),
      ),
    );

    final existingIndex = updatedSchedule.indexWhere(
          (item) => item['day']?.toString().toUpperCase() == day,
    );

    /// Ignore time selection if day is not selected.
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

  /// User tapped confirm.
  ///
  /// Calls:
  /// POST /api/member/pt-package-bookings
  Future<void> _onConfirmRequested(
      PtPackageBookingConfirmRequested event,
      Emitter<PtPackageBookingState> emit,
      ) async {
    final current = state;

    if (current is! PtPackageBookingLoaded || !current.canConfirm) {
      return;
    }

    final selectedPackage = current.selectedPackage!;

    emit(
      PtPackageBookingSubmitting(
        trainerId: current.trainerId,
        packages: current.packages,
        selectedPackage: current.selectedPackage,
        weeklySchedule: current.weeklySchedule,
        weeklySlotsByDay: current.weeklySlotsByDay,
        loadingSlotDays: current.loadingSlotDays,
        slotErrorsByDay: current.slotErrorsByDay,
      ),
    );

    final result = await _createPackageBookingUseCase(
      packageId: selectedPackage.id,
      weeklySchedule: current.weeklySchedule,
    );

    if (result.failure != null || result.data == null) {
      emit(
        PtPackageBookingError(
          trainerId: current.trainerId,
          packages: current.packages,
          selectedPackage: current.selectedPackage,
          weeklySchedule: current.weeklySchedule,
          weeklySlotsByDay: current.weeklySlotsByDay,
          loadingSlotDays: current.loadingSlotDays,
          slotErrorsByDay: current.slotErrorsByDay,
          message: result.failure?.message ?? 'ptPackageBookingFailed',
        ),
      );
      return;
    }

    emit(
      PtPackageBookingSuccess(
        trainerId: current.trainerId,
        packages: current.packages,
        selectedPackage: current.selectedPackage,
        weeklySchedule: current.weeklySchedule,
        weeklySlotsByDay: current.weeklySlotsByDay,
        loadingSlotDays: current.loadingSlotDays,
        slotErrorsByDay: current.slotErrorsByDay,
        booking: result.data!,
      ),
    );
  }

  /// Stable weekday codes accepted by backend.
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