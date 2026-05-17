// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/repositories/pt_service_repository.dart
// LAYER: Domain — Repository contract
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/pt_service_entity.dart';

abstract class PtServiceRepository {
  // ── READ ──────────────────────────────────────────────────────────────────
  /// [trainerId] = null → returns services for ALL trainers (admin view).
  Future<({List<PtServiceEntity>? data, Failure? failure})> getServices({
    int? trainerId,
    required int tenantId,
  });

  // ── CREATE ─────────────────────────────────────────────────────────────────
  Future<({PtServiceEntity? data, Failure? failure})> createService({
    required int trainerId,
    required int tenantId,
    required Map<String, dynamic> body,
  });

  // ── UPDATE ─────────────────────────────────────────────────────────────────
  Future<({PtServiceEntity? data, Failure? failure})> updateService(
      int serviceId,
      Map<String, dynamic> body,
      );

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<({bool success, Failure? failure})> deleteService(int serviceId);
}