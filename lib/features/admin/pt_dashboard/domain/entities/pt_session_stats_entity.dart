// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/entities/pt_session_stats_entity.dart
// LAYER: Domain
//
// Maps to TrainerPtSessionStatsResponse.
//
// Backend JSON:
//   { "total": 5, "completed": 2, "scheduled": 3, "requested": 1,
//     "checkedIn": 0, "cancelRequested": 0, "cancelled": 1, "noShow": 0 }
//
// Every status has its own explicit count from the backend — "cancelled" is
// never derived client-side as (total - completed - scheduled), since
// requested/checkedIn/cancelRequested sessions are not cancelled.
// =============================================================================

class PtSessionStatsEntity {
  /// Total sessions regardless of status for the selected date.
  final int total;

  final int completed;
  final int scheduled;
  final int requested;
  final int checkedIn;
  final int cancelRequested;
  final int cancelled;
  final int noShow;

  const PtSessionStatsEntity({
    required this.total,
    required this.completed,
    required this.scheduled,
    this.requested = 0,
    this.checkedIn = 0,
    this.cancelRequested = 0,
    this.cancelled = 0,
    this.noShow = 0,
  });

  static const empty = PtSessionStatsEntity(
    total: 0,
    completed: 0,
    scheduled: 0,
  );
}
