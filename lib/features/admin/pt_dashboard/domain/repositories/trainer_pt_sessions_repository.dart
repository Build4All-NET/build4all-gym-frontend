// =============================================================================
// FILE: lib/features/trainer/pt_sessions/domain/repositories/trainer_pt_sessions_repository.dart
// LAYER: Domain
//
// Abstract contract. The BLoC depends on this, never on the Impl.
// Swap in a FakeTrainerPtSessionsRepository in tests without touching HTTP.
// =============================================================================

import '../entities/pt_session_entity.dart';
import '../entities/pt_session_stats_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class TrainerPtSessionsRepository {
  /// GET /api/trainer/pt-sessions?branchId=&date=
  Future<({List<PtSessionEntity>? data, Failure? failure})> getSessionsByDate({
    required int branchId,
    required DateTime date,
  });

  /// GET /api/trainer/pt-sessions/stats?branchId=&date=
  Future<({PtSessionStatsEntity? data, Failure? failure})> getStatsByDate({
    required int branchId,
    required DateTime date,
  });

  /// POST /api/trainer/pt-sessions
  Future<({PtSessionEntity? data, Failure? failure})> createSession({
    required int branchId,
    required int userId,
    int? serviceId,
    int? memberPtPackageId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  });

  /// PATCH /api/trainer/pt-sessions/{id}/status
  Future<({PtSessionEntity? data, Failure? failure})> updateStatus({
    required int sessionId,
    required String status, // COMPLETED | CANCELLED | NO_SHOW
  });
}
