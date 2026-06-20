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

  /// PATCH /api/trainer/pt-sessions/{id}/payment-status — Admin/Owner/Manager
  /// only. Records that a standalone (non-package) session has been paid for.
  Future<({PtSessionEntity? data, Failure? failure})> markPaymentPaid({
    required int sessionId,
  });

  /// GET /api/trainer/pt-sessions/upcoming?branchId=&[trainerId=]
  Future<({List<PtSessionEntity>? data, Failure? failure})> getUpcoming({
    required int branchId,
    int? trainerId,
  });

  /// GET /api/trainer/pt-sessions/requests?branchId=&[trainerId=]
  Future<({List<PtSessionEntity>? data, Failure? failure})> getRequests({
    required int branchId,
    int? trainerId,
  });

  /// PATCH /api/trainer/pt-sessions/{id}/accept  (REQUESTED → SCHEDULED)
  Future<({PtSessionEntity? data, Failure? failure})> acceptRequest({
    required int sessionId,
  });

  /// PATCH /api/trainer/pt-sessions/{id}/decline  (REQUESTED → CANCELLED)
  Future<({PtSessionEntity? data, Failure? failure})> declineRequest({
    required int sessionId,
  });

  /// PATCH /api/trainer/pt-sessions/{id}/decline-cancel  (CANCEL_REQUESTED → SCHEDULED)
  Future<({PtSessionEntity? data, Failure? failure})> declineCancelRequest({
    required int sessionId,
  });
}
