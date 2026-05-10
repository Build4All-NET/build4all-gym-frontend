// =============================================================================
// FILE: lib/features/trainer/pt_sessions/domain/usecases/trainer_pt_sessions_usecases.dart
// LAYER: Domain
//
// All use cases for the trainer PT sessions feature, co-located in one file
// to match the admin/plans pattern used in this project.
// =============================================================================

import '../entities/pt_session_entity.dart';
import '../entities/pt_session_stats_entity.dart';
import '../repositories/trainer_pt_sessions_repository.dart';
import '../../../../core/errors/failure.dart';

// ── 1. Get sessions by date ──────────────────────────────────────────────────

class GetSessionsByDateUseCase {
  final TrainerPtSessionsRepository _repository;
  const GetSessionsByDateUseCase(this._repository);

  Future<({List<PtSessionEntity>? data, Failure? failure})> call({
    required int branchId,
    required DateTime date,
  }) =>
      _repository.getSessionsByDate(branchId: branchId, date: date);
}

// ── 2. Get session stats ────────────────────────────────────────────────────

class GetSessionStatsUseCase {
  final TrainerPtSessionsRepository _repository;
  const GetSessionStatsUseCase(this._repository);

  Future<({PtSessionStatsEntity? data, Failure? failure})> call({
    required int branchId,
    required DateTime date,
  }) =>
      _repository.getStatsByDate(branchId: branchId, date: date);
}

// ── 3. Create session ───────────────────────────────────────────────────────

class CreateSessionUseCase {
  final TrainerPtSessionsRepository _repository;
  const CreateSessionUseCase(this._repository);

  Future<({PtSessionEntity? data, Failure? failure})> call({
    required int branchId,
    required int userId,
    int? serviceId,
    int? memberPtPackageId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) =>
      _repository.createSession(
        branchId: branchId,
        userId: userId,
        serviceId: serviceId,
        memberPtPackageId: memberPtPackageId,
        startTime: startTime,
        endTime: endTime,
        notes: notes,
      );
}

// ── 4. Update session status ────────────────────────────────────────────────

class UpdateSessionStatusUseCase {
  final TrainerPtSessionsRepository _repository;
  const UpdateSessionStatusUseCase(this._repository);

  Future<({PtSessionEntity? data, Failure? failure})> call({
    required int sessionId,
    required String status,
  }) =>
      _repository.updateStatus(sessionId: sessionId, status: status);
}
