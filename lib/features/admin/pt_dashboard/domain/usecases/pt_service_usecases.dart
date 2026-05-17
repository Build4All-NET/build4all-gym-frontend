// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/usecases/pt_service_usecases.dart
// LAYER: Domain — Use Cases
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/pt_service_entity.dart';
import '../repositories/pt_service_repository.dart';

// ── 1. Get services ──────────────────────────────────────────────────────────

class GetPtServicesUseCase {
  final PtServiceRepository _repository;
  const GetPtServicesUseCase(this._repository);

  /// [trainerId] = null → admin mode, returns all trainers' services.
  Future<({List<PtServiceEntity>? data, Failure? failure})> call({
    int? trainerId,
    required int tenantId,
  }) =>
      _repository.getServices(trainerId: trainerId, tenantId: tenantId);
}

// ── 2. Create service ────────────────────────────────────────────────────────

class CreatePtServiceUseCase {
  final PtServiceRepository _repository;
  const CreatePtServiceUseCase(this._repository);

  Future<({PtServiceEntity? data, Failure? failure})> call({
    required int trainerId,
    required int tenantId,
    required Map<String, dynamic> body,
  }) =>
      _repository.createService(
        trainerId: trainerId,
        tenantId: tenantId,
        body: body,
      );
}

// ── 3. Update service ────────────────────────────────────────────────────────

class UpdatePtServiceUseCase {
  final PtServiceRepository _repository;
  const UpdatePtServiceUseCase(this._repository);

  Future<({PtServiceEntity? data, Failure? failure})> call(
      int serviceId,
      Map<String, dynamic> body,
      ) =>
      _repository.updateService(serviceId, body);
}

// ── 4. Delete service ────────────────────────────────────────────────────────

class DeletePtServiceUseCase {
  final PtServiceRepository _repository;
  const DeletePtServiceUseCase(this._repository);

  Future<({bool success, Failure? failure})> call(int serviceId) =>
      _repository.deleteService(serviceId);
}