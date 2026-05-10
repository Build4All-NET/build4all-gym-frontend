// =============================================================================
// FILE: lib/features/trainer/pt_sessions/domain/entities/pt_session_stats_entity.dart
// LAYER: Domain
//
// Maps to TrainerPtSessionStatsResponse.
//
// Backend JSON:
//   { "total": 5, "completed": 2, "scheduled": 3 }
//
// Screen layout (top of Sessions screen):
//   [ Today Sessions (blue) ] [ Completed (green) ] [ Upcoming (orange) ]
// =============================================================================

class PtSessionStatsEntity {
  /// Total sessions regardless of status for the selected date.
  final int total;

  /// Sessions with status = COMPLETED.
  final int completed;

  /// Sessions with status = SCHEDULED (shown as "Upcoming").
  final int scheduled;

  const PtSessionStatsEntity({
    required this.total,
    required this.completed,
    required this.scheduled,
  });

  static const empty = PtSessionStatsEntity(
    total: 0,
    completed: 0,
    scheduled: 0,
  );
}
