// ═══════════════════════════════════════════════════════════════════
// recent_activity.dart  ─  DOMAIN ENTITY
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   A wrapper around the list of RecentActivityItem objects.
//   The backend sends:
//     { "recentActivity": { "activities": [ {...}, {...} ] } }
//   instead of:
//     { "recentActivity": [ {...}, {...} ] }
//
//   This extra nesting makes the JSON extensible — the backend
//   can add a "totalCount" or "hasMore" field later without
//   breaking existing clients.
// ═══════════════════════════════════════════════════════════════════

import 'recent_activity_item.dart';

class RecentActivity {
  // The list of activity items, sorted newest-first.
  // Maximum 10 items (enforced by backend).
  // Can be empty [] if service is not yet implemented.
  final List<RecentActivityItem> activities;

  const RecentActivity({
    required this.activities,
  });
}