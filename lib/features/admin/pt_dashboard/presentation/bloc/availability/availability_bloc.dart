// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/availability_bloc.dart
//
// CHANGES vs previous version:
//   - _onCreate() now forwards event.specificDate to the CreateAvailabilitySlotUseCase.
// =============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/availability_entity.dart';
import '../../../domain/usecases/availability_usecases.dart';

part 'availability_event.dart';
part 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final GetAvailabilitySlotsUseCase    _getSlots;
  final CreateAvailabilitySlotUseCase  _createSlot;
  final DeleteAvailabilitySlotUseCase  _deleteSlot;

  // ── Keep last-load params so we can reload after a mutation ────────────────
  int?  _lastTrainerId;
  int   _lastBranchId = 0;

  AvailabilityBloc({
    required GetAvailabilitySlotsUseCase    getSlots,
    required CreateAvailabilitySlotUseCase  createSlot,
    required DeleteAvailabilitySlotUseCase  deleteSlot,
  })  : _getSlots   = getSlots,
        _createSlot = createSlot,
        _deleteSlot = deleteSlot,
        super(const AvailabilityInitial()) {
    on<AvailabilitySlotsLoadRequested>(_onLoad);
    on<AvailabilitySlotCreateRequested>(_onCreate);
    on<AvailabilitySlotDeleteRequested>(_onDelete);
  }

  // ── LOAD ───────────────────────────────────────────────────────────────────

  Future<void> _onLoad(
      AvailabilitySlotsLoadRequested event,
      Emitter<AvailabilityState> emit,
      ) async {
    _lastTrainerId = event.trainerId;
    _lastBranchId  = event.branchId;

    emit(const AvailabilityLoading());

    final result = await _getSlots(
      trainerId: event.trainerId,
      branchId:  event.branchId,
    );

    if (result.failure != null) {
      emit(AvailabilityError(result.failure!.message));
      return;
    }

    emit(AvailabilityLoaded(result.data ?? []));
  }

  // ── CREATE ─────────────────────────────────────────────────────────────────

  Future<void> _onCreate(
      AvailabilitySlotCreateRequested event,
      Emitter<AvailabilityState> emit,
      ) async {
    emit(const AvailabilityMutating());

    final result = await _createSlot(
      trainerId:    event.trainerId,
      branchId:     event.branchId,
      weekday:      event.weekday,
      startTime:    event.startTime,
      endTime:      event.endTime,
      recurring:    event.recurring,
      specificDate: event.specificDate,  // ← forwarded from event
    );

    if (result.failure != null) {
      emit(AvailabilityError(result.failure!.message));
      return;
    }

    emit(const AvailabilityMutationSuccess('Slot added successfully.'));
    _reload();
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  Future<void> _onDelete(
      AvailabilitySlotDeleteRequested event,
      Emitter<AvailabilityState> emit,
      ) async {
    emit(const AvailabilityMutating());

    final result = await _deleteSlot(event.availabilityId);

    if (result.failure != null) {
      emit(AvailabilityError(result.failure!.message));
      return;
    }

    emit(const AvailabilityMutationSuccess('Slot removed.'));
    _reload();
  }

  // ── Helper: reload with last known params ──────────────────────────────────

  void _reload() {
    if (_lastBranchId != 0) {
      add(AvailabilitySlotsLoadRequested(
        trainerId: _lastTrainerId,
        branchId:  _lastBranchId,
      ));
    }
  }
}
