// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/availability_bloc.dart
//
// FIX SUMMARY:
//   1. Uses proper events/states with Equatable
//   2. Supports null trainerId for admin all-trainers mode
//   3. Proper error handling
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/services/availability_service.dart';
import '../../data/models/availability_model.dart';

// ── Events ──────────────────────────────────────────────────────────────────

abstract class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();
  @override
  List<Object?> get props => [];
}

class LoadAvailability extends AvailabilityEvent {
  final int? trainerId; // null = all trainers (admin/owner)
  final int branchId;
  const LoadAvailability({this.trainerId, required this.branchId});

  @override
  List<Object?> get props => [trainerId, branchId];
}

class AddSlot extends AvailabilityEvent {
  final int trainerId;
  final int branchId;
  final int weekday;
  final String startTime;
  final String endTime;
  final bool recurring;
  const AddSlot({
    required this.trainerId,
    required this.branchId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    this.recurring = true,
  });

  @override
  List<Object?> get props => [trainerId, branchId, weekday, startTime, endTime, recurring];
}

class DeleteSlot extends AvailabilityEvent {
  final int availabilityId;
  const DeleteSlot(this.availabilityId);

  @override
  List<Object?> get props => [availabilityId];
}

// ── States ───────────────────────────────────────────────────────────────────

abstract class AvailabilityState extends Equatable {
  const AvailabilityState();
  @override
  List<Object?> get props => [];
}

class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

class AvailabilityLoading extends AvailabilityState {
  const AvailabilityLoading();
}

class AvailabilityLoaded extends AvailabilityState {
  final List<AvailabilityModel> slots;
  const AvailabilityLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class AvailabilityError extends AvailabilityState {
  final String message;
  const AvailabilityError(this.message);

  @override
  List<Object?> get props => [message];
}

class AvailabilityMutated extends AvailabilityState {
  const AvailabilityMutated();
}

// ── BLoC ─────────────────────────────────────────────────────────────────────

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final AvailabilityHttpService _svc;

  AvailabilityBloc(this._svc) : super(const AvailabilityInitial()) {
    on<LoadAvailability>(_onLoad);
    on<AddSlot>(_onAdd);
    on<DeleteSlot>(_onDelete);
  }

  Future<void> _onLoad(LoadAvailability e, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoading());
    try {
      final slots = await _svc.getSlots(trainerId: e.trainerId, branchId: e.branchId);
      emit(AvailabilityLoaded(slots));
    } catch (err) {
      emit(AvailabilityError(err.toString()));
    }
  }

  Future<void> _onAdd(AddSlot e, Emitter<AvailabilityState> emit) async {
    try {
      await _svc.createSlot(
        trainerId: e.trainerId,
        branchId:  e.branchId,
        weekday:   e.weekday,
        startTime: e.startTime,
        endTime:   e.endTime,
        recurring: e.recurring,
      );
      emit(const AvailabilityMutated());
    } catch (err) {
      emit(AvailabilityError(err.toString()));
    }
  }

  Future<void> _onDelete(DeleteSlot e, Emitter<AvailabilityState> emit) async {
    try {
      await _svc.deleteSlot(e.availabilityId);
      emit(const AvailabilityMutated());
    } catch (err) {
      emit(AvailabilityError(err.toString()));
    }
  }
}