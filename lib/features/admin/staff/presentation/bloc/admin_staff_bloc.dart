// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/bloc/admin_staff_bloc.dart
//
// FULL BLoC (not Cubit) as specified.
//
// DEBOUNCE STRATEGY:
//   StaffSearchChanged uses a dart:async Timer. Each new keystroke cancels the
//   previous timer so only the last query after 300 ms silence is executed.
//   This avoids flooding the API while the user is still typing.
//
// RELOAD AFTER ACTIONS:
//   After create/update/remove succeeds, the BLoC emits StaffActionSuccess
//   (which triggers the listener's snackbar) then adds a fresh StaffStarted
//   event to itself. This re-runs the full load cycle so totalStaff and
//   activeStaff are always up to date in the stats row.
//
// activeSearch / activeBranchId:
//   Stored as private fields so reload-after-action uses the same filters
//   the user last applied. Without this, the reload would clear the search.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_staff_usecase.dart';
import '../../domain/usecases/get_staff_usecase.dart';
import '../../domain/usecases/remove_staff_usecase.dart';
import '../../domain/usecases/update_staff_usecase.dart';
import 'admin_staff_event.dart';
import 'admin_staff_state.dart';

class AdminStaffBloc extends Bloc<AdminStaffEvent, AdminStaffState> {
  final GetStaffUseCase _getStaff;
  final CreateStaffUseCase _createStaff;
  final UpdateStaffUseCase _updateStaff;
  final RemoveStaffUseCase _removeStaff;

  // Internal filter state — preserved across action reloads.
  String? _activeSearch;
  int? _activeBranchId; // extend if branch picker is added to the screen

  Timer? _searchDebounce;

  AdminStaffBloc({
    required GetStaffUseCase getStaff,
    required CreateStaffUseCase createStaff,
    required UpdateStaffUseCase updateStaff,
    required RemoveStaffUseCase removeStaff,
  })  : _getStaff = getStaff,
        _createStaff = createStaff,
        _updateStaff = updateStaff,
        _removeStaff = removeStaff,
        super(const StaffInitial()) {
    on<StaffStarted>(_onStarted);
    on<StaffSearchChanged>(_onSearchChanged);
    on<StaffCreateRequested>(_onCreateRequested);
    on<StaffUpdateRequested>(_onUpdateRequested);
    on<StaffRemoveRequested>(_onRemoveRequested);
  }

  // ── StaffStarted ───────────────────────────────────────────────────────────

  Future<void> _onStarted(
      StaffStarted event,
      Emitter<AdminStaffState> emit,
      ) async {
    // Persist branch filter so reload-after-action keeps the same filter
    if (event.branchId != null) _activeBranchId = event.branchId;

    emit(const StaffLoading());
    try {
      final result = await _getStaff(
        branchId: _activeBranchId,
        search:   _activeSearch,
      );
      emit(StaffLoaded(
        staff:        result.staff,
        totalStaff:   result.totalStaff,
        activeStaff:  result.activeStaff,
        activeSearch: _activeSearch,
      ));
    } catch (e) {
      emit(StaffError(e.toString()));
    }
  }

  // ── StaffSearchChanged (debounced 300 ms) ──────────────────────────────────

  Future<void> _onSearchChanged(
      StaffSearchChanged event,
      Emitter<AdminStaffState> emit,
      ) async {
    // Cancel any pending debounce timer from a previous keystroke
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      // After silence, store the new query and trigger a fresh load
      _activeSearch = event.query.isEmpty ? null : event.query;
      add(const StaffStarted());
    });
  }

  // ── StaffCreateRequested ───────────────────────────────────────────────────

  Future<void> _onCreateRequested(
      StaffCreateRequested event,
      Emitter<AdminStaffState> emit,
      ) async {
    // staffId = 0 signals a CREATE action (no specific card to show spinner on)
    emit(const StaffActionLoading(0));
    try {
      final newStaffId = await _createStaff(event.request);
      emit(StaffActionSuccess(newStaffId, 'create'));
      // Reload so the new staff card appears and counts refresh
      add(const StaffStarted());
    } catch (e) {
      emit(StaffActionError(0, e.toString()));
    }
  }

  // ── StaffUpdateRequested ───────────────────────────────────────────────────

  Future<void> _onUpdateRequested(
      StaffUpdateRequested event,
      Emitter<AdminStaffState> emit,
      ) async {
    emit(StaffActionLoading(event.staffId));
    try {
      await _updateStaff(event.staffId, event.request);
      emit(StaffActionSuccess(event.staffId, 'update'));
      // Reload so the updated card fields are shown immediately
      add(const StaffStarted());
    } catch (e) {
      emit(StaffActionError(event.staffId, e.toString()));
    }
  }

  // ── StaffRemoveRequested ───────────────────────────────────────────────────

  Future<void> _onRemoveRequested(
      StaffRemoveRequested event,
      Emitter<AdminStaffState> emit,
      ) async {
    emit(StaffActionLoading(event.staffId));
    try {
      await _removeStaff(event.staffId);
      emit(StaffActionSuccess(event.staffId, 'remove'));
      // Reload removes the card and refreshes totalStaff / activeStaff counts
      add(const StaffStarted());
    } catch (e) {
      emit(StaffActionError(event.staffId, e.toString()));
    }
  }
  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}