// ═══════════════════════════════════════════════════════════════════
// checkin_stats.dart  ─  DOMAIN ENTITY
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   Represents attendance and PT session numbers.
//   The backend CheckinStatsService fills these from:
//     - CheckinRepository  (checkin table)
//     - PtSessionRepository (pt_session table)
//
// IMPORTANT NOTE on "period":
//   todayCheckins is ALWAYS today's count, regardless of the
//   ?period query param.
//   attendanceCount CHANGES based on ?period (today/week/month).
//   The Flutter UI passes the selected period to the API call.
// ═══════════════════════════════════════════════════════════════════

class CheckinStats {
  // ── Check-ins that happened today (00:00 → 23:59) ────────────────
  // Always "today", not affected by the period dropdown.
  // Shown in "Today's Check-ins" large card. Example: 89 (screenshot)
  // But the backend returns "2" for this test tenant.
  final int todayCheckins;

  // ── Check-ins during the selected period ─────────────────────────
  // period=today  → same as todayCheckins
  // period=week   → last 7 days
  // period=month  → last 30 days
  // Shown in "Attendance" small card.
  final int attendanceCount;

  // ── % growth vs same-length window one week earlier ──────────────
  // Example: attendanceCount=12, previousCount=10 → growth=20.0%
  // Shown as "+12%" badge on the Attendance card.
  final double attendanceGrowth;

  // ── PT services scheduled in the FUTURE with status=SCHEDULED ────
  // Shown in "Upcoming PT" large card. Example: 15
  // Gives the owner a heads-up on upcoming trainer load.
  final int upcomingPTSessions;

  const CheckinStats({
    required this.todayCheckins,
    required this.attendanceCount,
    required this.attendanceGrowth,
    required this.upcomingPTSessions,
  });
}