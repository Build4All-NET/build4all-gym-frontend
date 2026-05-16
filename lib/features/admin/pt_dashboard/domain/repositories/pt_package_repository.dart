// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/repositories/pt_package_repository.dart
// LAYER: Domain — Repository contract
//
// All data-layer details (HTTP, exceptions) are hidden behind this interface.
// The BLoC depends ONLY on this abstraction — never on the concrete impl.
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/pt_package_entity.dart';

abstract class PtPackageRepository {
  // ── READ ──────────────────────────────────────────────────────────────────
  /// [trainerId] = null → admin/owner mode, returns ALL trainers' packages.
  /// [trainerId] = id   → trainer mode, returns only that trainer's packages.
  Future<({List<PtPackageEntity>? data, Failure? failure})> getPackages({
    int? trainerId,
    required int tenantId,
    required int branchId,
  });

  // ── CREATE ─────────────────────────────────────────────────────────────────
  /// Admin/owner can pass any trainerId to assign the package to a trainer.
  Future<({PtPackageEntity? data, Failure? failure})> createPackage({
    required int trainerId,
    required int tenantId,
    required int branchId,
    required Map<String, dynamic> body,
  });

  // ── UPDATE ─────────────────────────────────────────────────────────────────
  Future<({PtPackageEntity? data, Failure? failure})> updatePackage(
      int id,
      Map<String, dynamic> body,
      );

  // ── READ INACTIVE ─────────────────────────────────────────────────────────
  Future<({List<PtPackageEntity>? data, Failure? failure})> getInactivePackages({
    int? trainerId,
    required int tenantId,
    required int branchId,
  });

  // ── DELETE (deactivate) ───────────────────────────────────────────────────
  Future<({bool success, Failure? failure})> deactivatePackage(int id);
}