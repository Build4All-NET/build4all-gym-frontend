// =============================================================================
// FILE: lib/features/trainer/pt_sessions/data/repositories/trainer_pt_sessions_repository_impl.dart
// LAYER: Data — implements the domain contract
//
// Catches infrastructure exceptions → wraps them as domain Failures.
// The BLoC never sees HTTP exceptions — only Failure subtypes.
// =============================================================================

import '../../domain/entities/pt_session_entity.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import '../../domain/repositories/trainer_pt_sessions_repository.dart';
import '../models/pt_session_stats_model.dart';
import '../services/trainer_pt_sessions_service.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;

class TrainerPtSessionsRepositoryImpl implements TrainerPtSessionsRepository {
  final TrainerPtSessionsService _service;

  const TrainerPtSessionsRepositoryImpl({
    required TrainerPtSessionsService service,
  }) : _service = service;

  // ── Get sessions by date ────────────────────────────────────────────────────

  @override
  Future<({List<PtSessionEntity>? data, Failure? failure})> getSessionsByDate({
    required int branchId,
    required DateTime date,
  }) async {
    try {
      final models = await _service.getSessionsByDate(
        branchId: branchId,
        date: date,
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

  // ── Get stats by date ───────────────────────────────────────────────────────

  @override
  Future<({PtSessionStatsEntity? data, Failure? failure})> getStatsByDate({
    required int branchId,
    required DateTime date,
  }) async {
    try {
      final model = await _service.getStatsByDate(
        branchId: branchId,
        date: date,
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

  // ── Create session ──────────────────────────────────────────────────────────

  @override
  Future<({PtSessionEntity? data, Failure? failure})> createSession({
    required int branchId,
    required int userId,
    int? serviceId,
    int? memberPtPackageId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{
        'branchId': branchId,
        'userId': userId,
        if (serviceId != null) 'serviceId': serviceId,
        if (memberPtPackageId != null) 'memberPtPackageId': memberPtPackageId,
        'startTime': startTime.toIso8601String().substring(0, 19),
        'endTime': endTime.toIso8601String().substring(0, 19),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final model = await _service.createSession(body);
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

  // ── Update status ───────────────────────────────────────────────────────────

  @override
  Future<({PtSessionEntity? data, Failure? failure})> updateStatus({
    required int sessionId,
    required String status,
  }) async {
    try {
      final model = await _service.updateStatus(sessionId, status);
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
}
