// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/usecases/pt_package_usecases.dart
// LAYER: Domain — Use Cases
//
// All use cases for PT package management, co-located in one file
// to match the admin/plans and trainer_pt_sessions patterns.
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/pt_package_entity.dart';
import '../repositories/pt_package_repository.dart';

// ── 1. Get packages ──────────────────────────────────────────────────────────

class GetPtPackagesUseCase {
  final PtPackageRepository _repository;
  const GetPtPackagesUseCase(this._repository);

  /// [trainerId] = null → admin/owner mode, returns all trainers' packages.
  Future<({List<PtPackageEntity>? data, Failure? failure})> call({
    int? trainerId,
    required int tenantId,
    required int branchId,
  }) =>
      _repository.getPackages(
        trainerId: trainerId,
        tenantId: tenantId,
        branchId: branchId,
      );
}

// ── 2. Create package ────────────────────────────────────────────────────────

class CreatePtPackageUseCase {
  final PtPackageRepository _repository;
  const CreatePtPackageUseCase(this._repository);

  Future<({PtPackageEntity? data, Failure? failure})> call({
    required int trainerId,
    required int tenantId,
    required int branchId,
    required Map<String, dynamic> body,
  }) =>
      _repository.createPackage(
        trainerId: trainerId,
        tenantId: tenantId,
        branchId: branchId,
        body: body,
      );
}

// ── 3. Update package ────────────────────────────────────────────────────────

class UpdatePtPackageUseCase {
  final PtPackageRepository _repository;
  const UpdatePtPackageUseCase(this._repository);

  Future<({PtPackageEntity? data, Failure? failure})> call(
      int id,
      Map<String, dynamic> body,
      ) =>
      _repository.updatePackage(id, body);
}

// ── 4. Get inactive packages ─────────────────────────────────────────────────

class GetInactivePtPackagesUseCase {
  final PtPackageRepository _repository;
  const GetInactivePtPackagesUseCase(this._repository);

  Future<({List<PtPackageEntity>? data, Failure? failure})> call({
    int? trainerId,
    required int tenantId,
    required int branchId,
  }) =>
      _repository.getInactivePackages(
        trainerId: trainerId,
        tenantId: tenantId,
        branchId: branchId,
      );
}

// ── 5. Deactivate (soft-delete) package ─────────────────────────────────────

class DeactivatePtPackageUseCase {
  final PtPackageRepository _repository;
  const DeactivatePtPackageUseCase(this._repository);

  Future<({bool success, Failure? failure})> call(int id) =>
      _repository.deactivatePackage(id);
}