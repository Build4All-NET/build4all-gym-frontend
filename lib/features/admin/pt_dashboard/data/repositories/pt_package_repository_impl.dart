// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/repositories/pt_package_repository_impl.dart
// LAYER: Data — Repository implementation
//
// Catches all infrastructure exceptions and wraps them as domain Failures.
// The BLoC only ever sees Failure subtypes — never raw HTTP exceptions.
//
// FLOW:
//   PtPackageBloc
//     → GetPtPackagesUseCase / CreatePtPackageUseCase / ...
//     → [this class] PtPackageRepositoryImpl
//     → PtPackageService  (raw HTTP)
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/pt_package_entity.dart';
import '../../domain/repositories/pt_package_repository.dart';
import '../models/pt_package_model.dart';
import '../services/pt_package_service.dart';

class PtPackageRepositoryImpl implements PtPackageRepository {
  final PtPackageService _service;

  const PtPackageRepositoryImpl({required PtPackageService service})
      : _service = service;

  // ── READ ──────────────────────────────────────────────────────────────────

  @override
  Future<({List<PtPackageEntity>? data, Failure? failure})> getPackages({
    int? trainerId,
    required int tenantId,
    required int branchId,
  }) async {
    try {
      final models = await _service.getPackages(
        trainerId: trainerId,
        tenantId:  tenantId,
        branchId:  branchId,
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
  Future<({PtPackageEntity? data, Failure? failure})> createPackage({
    required int trainerId,
    required int tenantId,
    required int branchId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final model = await _service.createPackage(
        trainerId: trainerId,
        tenantId:  tenantId,
        branchId:  branchId,
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
  Future<({PtPackageEntity? data, Failure? failure})> updatePackage(
      int id,
      Map<String, dynamic> body,
      ) async {
    try {
      final model = await _service.updatePackage(id, body);
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

  // ── READ INACTIVE ─────────────────────────────────────────────────────────

  @override
  Future<({List<PtPackageEntity>? data, Failure? failure})> getInactivePackages({
    int? trainerId,
    required int tenantId,
    required int branchId,
  }) async {
    try {
      final models = await _service.getInactivePackages(
        trainerId: trainerId,
        tenantId:  tenantId,
        branchId:  branchId,
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

  // ── DEACTIVATE ─────────────────────────────────────────────────────────────

  @override
  Future<({bool success, Failure? failure})> deactivatePackage(int id) async {
    try {
      await _service.deactivatePackage(id);
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