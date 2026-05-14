// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_service_bloc.dart
//
// FIX SUMMARY:
//   1. Uses proper events/states with Equatable
//   2. Proper error handling
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/services/pt_service_service.dart';
import '../../data/models/pt_service_model.dart';

// ── Events ──────────────────────────────────────────────────────────────────

abstract class PtServiceEvent extends Equatable {
  const PtServiceEvent();
  @override
  List<Object?> get props => [];
}

class LoadServices extends PtServiceEvent {
  final int tenantId;
  const LoadServices(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class CreateService extends PtServiceEvent {
  final int tenantId;
  final Map<String, dynamic> data;
  const CreateService({required this.tenantId, required this.data});

  @override
  List<Object?> get props => [tenantId, data];
}

class UpdateService extends PtServiceEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateService({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

// ── States ───────────────────────────────────────────────────────────────────

abstract class PtServiceState extends Equatable {
  const PtServiceState();
  @override
  List<Object?> get props => [];
}

class PtServiceInitial extends PtServiceState {
  const PtServiceInitial();
}

class PtServiceLoading extends PtServiceState {
  const PtServiceLoading();
}

class PtServiceLoaded extends PtServiceState {
  final List<PtServiceModel> services;
  const PtServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class PtServiceError extends PtServiceState {
  final String message;
  const PtServiceError(this.message);

  @override
  List<Object?> get props => [message];
}

class PtServiceMutated extends PtServiceState {
  const PtServiceMutated();
}

// ── BLoC ─────────────────────────────────────────────────────────────────────

class PtServiceBloc extends Bloc<PtServiceEvent, PtServiceState> {
  final PtServiceService _svc;

  PtServiceBloc(this._svc) : super(const PtServiceInitial()) {
    on<LoadServices>(_onLoad);
    on<CreateService>(_onCreate);
    on<UpdateService>(_onUpdate);
  }

  Future<void> _onLoad(LoadServices e, Emitter<PtServiceState> emit) async {
    emit(const PtServiceLoading());
    try {
      final services = await _svc.getServices(e.tenantId);
      emit(PtServiceLoaded(services));
    } catch (err) {
      emit(PtServiceError(err.toString()));
    }
  }

  Future<void> _onCreate(CreateService e, Emitter<PtServiceState> emit) async {
    try {
      await _svc.createService(e.tenantId, e.data);
      emit(const PtServiceMutated());
    } catch (err) {
      emit(PtServiceError(err.toString()));
    }
  }

  Future<void> _onUpdate(UpdateService e, Emitter<PtServiceState> emit) async {
    try {
      await _svc.updateService(e.id, e.data);
      emit(const PtServiceMutated());
    } catch (err) {
      emit(PtServiceError(err.toString()));
    }
  }
}