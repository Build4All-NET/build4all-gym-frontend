// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/repositories/availability_repository_impl.dart
// LAYER: Data — Repository implementation
//
// CHANGES vs previous version:
//   - createSlot() forwards optional `specificDate` to AvailabilityHttpService.
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/availability_entity.dart';
import '../../domain/repositories/availability_repository.dart';
import '../services/availability_service.dart';

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final AvailabilityHttpService _service;

  const AvailabilityRepositoryImpl({required AvailabilityHttpService service})
      : _service = service;

  // ── READ ───────────────────────────────────────────────────────────────────

  @override
  Future<({List<AvailabilityEntity>? data, Failure? failure})> getSlots({
    int? trainerId,
    required int branchId,
  }) async {
    try {
      final models = await _service.getSlots(
        trainerId: trainerId,
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
  Future<({AvailabilityEntity? data, Failure? failure})> createSlot({
    required int trainerId,
    required int branchId,
    required int weekday,
    required String startTime,
    required String endTime,
    bool recurring = true,
    DateTime? specificDate,
  }) async {
    try {
      final model = await _service.createSlot(
        trainerId:    trainerId,
        branchId:     branchId,
        weekday:      weekday,
        startTime:    startTime,
        endTime:      endTime,
        recurring:    recurring,
        specificDate: specificDate,
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

  // ── DELETE ─────────────────────────────────────────────────────────────────

  @override
  Future<({bool success, Failure? failure})> deleteSlot(
      int availabilityId) async {
    try {
      await _service.deleteSlot(availabilityId);
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
