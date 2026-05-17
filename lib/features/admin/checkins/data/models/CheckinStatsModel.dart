// =============================================================================
// FILE: checkin_stats_model.dart
// PATH: lib/features/admin/checkins/data/models/checkin_stats_model.dart
// LAYER: Data Layer → Models
//
// PURPOSE:
//   Parses the stats portion of the GET /api/admin/checkins/today response.
//
// BACKEND SHAPE (top-level fields in TodayCheckinsResponse):
//   {
//     "activeNow":  5,
//     "totalToday": 6,
//     "checkins":   [...]
//   }
// =============================================================================

import '../../domain/entities/checkin_stats.dart';

class CheckinStatsModel {
  final int activeNow;
  final int totalToday;

  const CheckinStatsModel({
    required this.activeNow,
    required this.totalToday,
  });

  factory CheckinStatsModel.fromJson(Map<String, dynamic> json) {
    return CheckinStatsModel(
      activeNow:  (json['activeNow']  as num?)?.toInt() ?? 0,
      totalToday: (json['totalToday'] as num?)?.toInt() ?? 0,
    );
  }

  CheckinStats toEntity() {
    return CheckinStats(activeNow: activeNow, totalToday: totalToday);
  }
}
