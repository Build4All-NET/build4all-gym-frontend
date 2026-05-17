// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_service_bloc.dart
// LAYER: Presentation — BLoC
//
// Uses domain use cases — never imports from data layer directly.
// =============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/pt_service_entity.dart';
import '../../../domain/usecases/pt_service_usecases.dart';

part 'pt_service_event.dart';
part 'pt_service_state.dart';

class PtServiceBloc extends Bloc<PtServiceEvent, PtServiceState> {
  final GetPtServicesUseCase    _getServices;
  final CreatePtServiceUseCase  _createService;
  final UpdatePtServiceUseCase  _updateService;
  final DeletePtServiceUseCase  _deleteService;

  // ── Keep last-load params for post-mutation reload ────────────────────────
  int?  _lastTrainerId;
  int   _lastTenantId = 0;

  PtServiceBloc({
    required GetPtServicesUseCase    getServices,
    required CreatePtServiceUseCase  createService,
    required UpdatePtServiceUseCase  updateService,
    required DeletePtServiceUseCase  deleteService,
  })  : _getServices   = getServices,
        _createService  = createService,
        _updateService  = updateService,
        _deleteService  = deleteService,
        super(const PtServiceInitial()) {
    on<PtServicesLoadRequested>(_onLoad);
    on<PtServiceCreateRequested>(_onCreate);
    on<PtServiceUpdateRequested>(_onUpdate);
    on<PtServiceDeleteRequested>(_onDelete);
  }

  // ── LOAD ───────────────────────────────────────────────────────────────────

  Future<void> _onLoad(
      PtServicesLoadRequested event,
      Emitter<PtServiceState> emit,
      ) async {
    _lastTrainerId = event.trainerId;
    _lastTenantId  = event.tenantId;

    emit(const PtServiceLoading());

    final result = await _getServices(
      trainerId: event.trainerId,
      tenantId:  event.tenantId,
    );

    if (result.failure != null) {
      emit(PtServiceError(result.failure!.message));
      return;
    }

    emit(PtServiceLoaded(result.data ?? []));
  }

  // ── CREATE ─────────────────────────────────────────────────────────────────

  Future<void> _onCreate(
      PtServiceCreateRequested event,
      Emitter<PtServiceState> emit,
      ) async {
    emit(const PtServiceMutating());

    final result = await _createService(
      trainerId: event.trainerId,
      tenantId:  event.tenantId,
      body:      event.body,
    );

    if (result.failure != null) {
      emit(PtServiceError(result.failure!.message));
      return;
    }

    emit(const PtServiceMutationSuccess('Service created successfully.'));
    _reload();
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────

  Future<void> _onUpdate(
      PtServiceUpdateRequested event,
      Emitter<PtServiceState> emit,
      ) async {
    emit(const PtServiceMutating());

    final result = await _updateService(event.serviceId, event.body);

    if (result.failure != null) {
      emit(PtServiceError(result.failure!.message));
      return;
    }

    emit(const PtServiceMutationSuccess('Service updated successfully.'));
    _reload();
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  Future<void> _onDelete(
      PtServiceDeleteRequested event,
      Emitter<PtServiceState> emit,
      ) async {
    emit(const PtServiceMutating());

    final result = await _deleteService(event.serviceId);

    if (result.failure != null) {
      emit(PtServiceError(result.failure!.message));
      return;
    }

    emit(const PtServiceMutationSuccess('Service deleted.'));
    _reload();
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  void _reload() {
    if (_lastTenantId != 0) {
      add(PtServicesLoadRequested(
        trainerId: _lastTrainerId,
        tenantId:  _lastTenantId,
      ));
    }
  }
}