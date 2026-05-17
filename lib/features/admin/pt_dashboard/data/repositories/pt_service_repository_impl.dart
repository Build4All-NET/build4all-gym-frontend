// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/repositories/pt_service_repository_impl.dart
// LAYER: Data — Repository implementation
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/pt_service_entity.dart';
import '../../domain/repositories/pt_service_repository.dart';
import '../services/pt_service_service.dart';

class PtServiceRepositoryImpl implements PtServiceRepository {
  final PtServiceService _service;

  const PtServiceRepositoryImpl({required PtServiceService service})
      : _service = service;

  // ── READ ──────────────────────────────────────────────────────────────────

  @override
  Future<({List<PtServiceEntity>? data, Failure? failure})> getServices({
    int? trainerId,
    required int tenantId,
  }) async {
    try {
      final models = await _service.getServices(
        trainerId: trainerId,
        tenantId:  tenantId,
      );
      return (data: models.map((m) => m.toEntity()).toList(), failure: null);
    } on UnauthorizedException {
      return (data: null, failure: const AuthFailure('Session expired. Please log in again.'));
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }

  // ── CREATE ─────────────────────────────────────────────────────────────────

  @override
  Future<({PtServiceEntity? data, Failure? failure})> createService({
    required int trainerId,
    required int tenantId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final model = await _service.createService(
        trainerId: trainerId,
        tenantId:  tenantId,
        body:      body,
      );
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (data: null, failure: const AuthFailure('Session expired. Please log in again.'));
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────

  @override
  Future<({PtServiceEntity? data, Failure? failure})> updateService(
      int serviceId,
      Map<String, dynamic> body,
      ) async {
    try {
      final model = await _service.updateService(serviceId, body);
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (data: null, failure: const AuthFailure('Session expired. Please log in again.'));
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  @override
  Future<({bool success, Failure? failure})> deleteService(
      int serviceId) async {
    try {
      await _service.deleteService(serviceId);
      return (success: true, failure: null);
    } on UnauthorizedException {
      return (success: false, failure: const AuthFailure('Session expired. Please log in again.'));
    } on ForbiddenException {
      return (success: false, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (success: false, failure: ServerFailure(e.message));
    } on NetworkException {
      return (success: false, failure: const NetworkFailure('No internet connection.'));
    }
  }
}