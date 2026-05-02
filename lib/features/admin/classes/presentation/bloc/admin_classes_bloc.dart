// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/bloc/admin_classes_bloc.dart
//
// PURPOSE:
//   The brain of the admin classes feature. Receives events from the UI,
//   calls use cases, emits states back to the UI.
//
// FLOW PER EVENT:
//   1. UI dispatches event (e.g. ClassesStarted)
//   2. BLoC handler runs: emits loading state → calls use case → emits result state
//   3. UI BlocBuilder/BlocConsumer rebuilds based on new state
//
// The BLoC holds ONE piece of mutable state: _selectedDate.
// This is needed so that after create/update/cancel the list can be refreshed
// for the same date the admin was viewing.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cancel_class_request_model.dart';
import '../../domain/usecases/cancel_class_usecase.dart';
import '../../domain/usecases/create_class_usecase.dart';
import '../../domain/usecases/get_class_form_options_usecase.dart';
import '../../domain/usecases/get_classes_by_date_usecase.dart';
import '../../domain/usecases/get_session_bookings_usecase.dart';
import '../../domain/usecases/update_class_usecase.dart';
import 'admin_classes_event.dart';
import 'admin_classes_state.dart';
class AdminClassesBloc extends Bloc<AdminClassesEvent, AdminClassesState> {

  // All 6 use cases injected via constructor
  final GetClassesByDateUseCase      _getClassesByDate;
  final GetClassFormOptionsUseCase   _getClassFormOptions;
  final CreateClassUseCase           _createClass;
  final UpdateClassUseCase           _updateClass;
  final CancelClassUseCase           _cancelClass;
  final GetSessionBookingsUseCase    _getSessionBookings;

  // The date the admin is currently viewing — persisted across events
  // so after a mutation we can refresh the right date's list
  DateTime _selectedDate = DateTime.now();

  AdminClassesBloc({
    required GetClassesByDateUseCase      getClassesByDate,
    required GetClassFormOptionsUseCase   getClassFormOptions,
    required CreateClassUseCase           createClass,
    required UpdateClassUseCase           updateClass,
    required CancelClassUseCase           cancelClass,
    required GetSessionBookingsUseCase    getSessionBookings,
  })  : _getClassesByDate    = getClassesByDate,
        _getClassFormOptions  = getClassFormOptions,
        _createClass          = createClass,
        _updateClass          = updateClass,
        _cancelClass          = cancelClass,
        _getSessionBookings   = getSessionBookings,
        super(ClassesInitial()) {

    on<ClassesStarted>(_onClassesStarted);
    on<ClassesDateChanged>(_onClassesDateChanged);
    on<ClassFormOptionsRequested>(_onClassFormOptionsRequested);
    on<ClassCreateRequested>(_onClassCreateRequested);
    on<ClassUpdateRequested>(_onClassUpdateRequested);
    on<ClassCancelRequested>(_onClassCancelRequested);
    on<SessionBookingsRequested>(_onSessionBookingsRequested);
  }

  // ── ClassesStarted ──────────────────────────────────────────────────────
  // First event dispatched from AdminClassesScreen.initState.
  // Also re-dispatched by action handlers to refresh the list after mutations.
  Future<void> _onClassesStarted(
      ClassesStarted event, Emitter<AdminClassesState> emit) async {
    _selectedDate = event.date;
    emit(ClassesLoading());
    try {
      // Format DateTime → "yyyy-MM-dd" string the service expects
      final dateStr = _formatDate(event.date);
      final classes = await _getClassesByDate(dateStr, null);
      emit(ClassesLoaded(classes, _selectedDate));
    } catch (e) {
      emit(ClassesError(e.toString()));
    }
  }

  // ── ClassesDateChanged ──────────────────────────────────────────────────
  // Tapping a date chip in the filter row dispatches this.
  // Identical to ClassesStarted but preserves context that it was a date change.
  Future<void> _onClassesDateChanged(
      ClassesDateChanged event, Emitter<AdminClassesState> emit) async {
    _selectedDate = event.date;
    emit(ClassesLoading());
    try {
      final dateStr = _formatDate(event.date);
      final classes = await _getClassesByDate(dateStr, null);
      emit(ClassesLoaded(classes, _selectedDate));
    } catch (e) {
      emit(ClassesError(e.toString()));
    }
  }

  // ── ClassFormOptionsRequested ───────────────────────────────────────────
  // Dispatched when the Add/Edit bottom sheet opens — loads all 3 dropdowns.
  Future<void> _onClassFormOptionsRequested(
      ClassFormOptionsRequested event, Emitter<AdminClassesState> emit) async {
    emit(ClassFormOptionsLoading());
    try {
      final options = await _getClassFormOptions(event.branchId);
      emit(ClassFormOptionsLoaded(options));
    } catch (e) {
      emit(ClassesError(e.toString()));
    }
  }

  // ── ClassCreateRequested ────────────────────────────────────────────────
  // Dispatched when Save Class is tapped in the Add New Class sheet.
  // On success: emits ClassActionSuccess then refreshes the list.
  Future<void> _onClassCreateRequested(
      ClassCreateRequested event, Emitter<AdminClassesState> emit) async {
    emit(const ClassActionLoading(0)); // 0 = no specific card (creating new)
    try {
      final sessionId = await _createClass(event.request);
      emit(ClassActionSuccess(sessionId, 'created'));
      // Refresh the list so the new class appears
      add(ClassesStarted(_selectedDate));
    } catch (e) {
      emit(ClassActionError(0, e.toString()));
    }
  }

  // ── ClassUpdateRequested ────────────────────────────────────────────────
  Future<void> _onClassUpdateRequested(
      ClassUpdateRequested event, Emitter<AdminClassesState> emit) async {
    emit(ClassActionLoading(event.sessionId));
    try {
      await _updateClass(event.sessionId, event.request);
      emit(ClassActionSuccess(event.sessionId, 'updated'));
      add(ClassesStarted(_selectedDate));
    } catch (e) {
      emit(ClassActionError(event.sessionId, e.toString()));
    }
  }

  // ── ClassCancelRequested ────────────────────────────────────────────────
  Future<void> _onClassCancelRequested(
      ClassCancelRequested event, Emitter<AdminClassesState> emit) async {
    emit(ClassActionLoading(event.sessionId));
    try {
      await _cancelClass(
          event.sessionId, CancelClassRequestModel(cancelReason: event.cancelReason));
      emit(ClassActionSuccess(event.sessionId, 'cancelled'));
      add(ClassesStarted(_selectedDate));
    } catch (e) {
      emit(ClassActionError(event.sessionId, e.toString()));
    }
  }

  // ── SessionBookingsRequested ────────────────────────────────────────────
  // Dispatched when Bookings is tapped on a card.
  // The SessionBookingsBottomSheet listens for SessionBookingsLoaded to render.
  Future<void> _onSessionBookingsRequested(
      SessionBookingsRequested event, Emitter<AdminClassesState> emit) async {
    emit(SessionBookingsLoading(event.sessionId));
    try {
      final bookings = await _getSessionBookings(event.sessionId);
      emit(SessionBookingsLoaded(event.sessionId, bookings));
    } catch (e) {
      emit(ClassActionError(event.sessionId, e.toString()));
    }
  }

  // ── Private: format DateTime → "yyyy-MM-dd" ─────────────────────────────
  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}