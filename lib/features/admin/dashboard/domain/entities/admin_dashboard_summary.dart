// ═══════════════════════════════════════════════════════════════════
// admin_dashboard_summary.dart  ─  DOMAIN ENTITY (ROOT)
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   The ROOT entity that holds everything the admin dashboard needs.
//   This maps to the full response of GET /api/admin/dashboard.
//
// JSON STRUCTURE (from AdminDashboardSummaryDto):
//   {
//     "period": "today",
//     "members":       { ...8 fields... },
//     "plans":         { ...3 fields... },
//     "checkins":      { ...4 fields... },
//     "revenue":       { ...4 fields... }  ← null if caller is ADMIN
//     "recentActivity":{ "activities": [] }
//   }
//
// NULLABILITY RULE:
//   revenue is Revenue? (nullable) because:
//   - OWNER role → backend sends revenue object with real data
//   - ADMIN role → backend sends "revenue": null
//   All other 4 fields are NEVER null — backend always provides them.
//
// FLOW REMINDER:
//   AdminDashboardController (Java)
//     → JSON over HTTP
//       → AdminDashboardSummaryModel.fromJson() (data layer)
//         → AdminDashboardSummaryModel.toEntity()
//           → AdminDashboardSummary  ← THIS FILE
//             → BLoC state → Screen → Widgets
// ═══════════════════════════════════════════════════════════════════

import 'member_stats.dart';
import 'plan_stats.dart';
import 'checkin_stats.dart';
import 'revenue.dart';
import 'recent_activity.dart';

class AdminDashboardSummary {
  // Which period the data is filtered by.
  // Comes from the ?period query param.
  // Values: "today" | "week" | "month"
  // The Flutter dropdown controls this, sends it to the API.
  final String period;

  // All 8 member-related metrics (activeMembers, churnRate, etc.)
  final MemberStats members;

  // Plan counts (totalPlans, activePlans, expiredPlans)
  final PlanStats plans;

  // Attendance and PT session numbers
  final CheckinStats checkins;

  // Financial stats — NULL if the logged-in user is ADMIN (not OWNER)
  // The widget checks: if (summary.revenue != null) → show revenue cards
  final Revenue? revenue;

  // Recent activity feed (last 10 events)
  final RecentActivity recentActivity;

  const AdminDashboardSummary({
    required this.period,
    required this.members,
    required this.plans,
    required this.checkins,
    this.revenue,       // optional — null for ADMIN role
    required this.recentActivity,
  });
}