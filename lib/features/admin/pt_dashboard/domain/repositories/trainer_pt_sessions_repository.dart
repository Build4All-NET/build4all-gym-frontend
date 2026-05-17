// =============================================================================
// FILE: lib/features/trainer/pt_sessions/domain/repositories/trainer_pt_sessions_repository.dart
// LAYER: Domain
//
// Abstract contract. The BLoC depends on this, never on the Impl.
// Swap in a FakeTrainerPtSessionsRepository in tests without touching HTTP.
// =============================================================================

import '../entities/pt_session_entity.dart';
import '../entities/pt_session_stats_entity.dart';
import '../../../../../core/error/failures.dart';

abstract class TrainerPtSessionsRepository {
  /// GET /api/trainer/pt-services?branchId=&date=[&trainerId=]
  Future<({List<PtSessionEntity>? data, Failure? failure})> getSessionsByDate({
    required int branchId,
    int? trainerId,
    required DateTime date,
  });

  /// GET /api/trainer/pt-services/stats?branchId=&date=[&trainerId=]
  Future<({PtSessionStatsEntity? data, Failure? failure})> getStatsByDate({
    required int branchId,
    int? trainerId,
    required DateTime date,
  });

  /// POST /api/trainer/pt-services[?trainerId=]
  Future<({PtSessionEntity? data, Failure? failure})> createSession({
    required int branchId,
    int? trainerId,
    required int userId,
    int? serviceId,
    int? memberPtPackageId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  });

  /// PATCH /api/trainer/pt-services/{id}/status
  Future<({PtSessionEntity? data, Failure? failure})> updateStatus({
    required int sessionId,
    required String status, // COMPLETED | CANCELLED | NO_SHOW
  });
}
