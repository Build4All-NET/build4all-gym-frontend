// =============================================================================
// FILE: checkin_stats.dart
// PATH: lib/features/admin/checkins/domain/entities/checkin_stats.dart
// LAYER: Domain Layer → Entities
//
// PURPOSE:
//   Holds the two stat-card values shown at the top of the check-ins screen:
//     • activeNow  — how many members are currently inside
//     • totalToday — total check-ins for today (regardless of status)
// =============================================================================

class CheckinStats {
  final int activeNow;
  final int totalToday;

  const CheckinStats({
    required this.activeNow,
    required this.totalToday,
  });

  /// Fallback used while loading — both cards show "–" until data arrives.
  const CheckinStats.empty()
      : activeNow  = 0,
        totalToday = 0;
}
