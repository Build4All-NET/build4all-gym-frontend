// ═══════════════════════════════════════════════════════════════════
// recent_activity_item.dart  ─  DOMAIN ENTITY
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   Represents ONE row in the "Recent Activity" feed at the bottom
//   of the dashboard.
//
// SHOWN IN UI:
//   [AR]  Ananya Reddy
//         Joined Premium Monthly
//         2 hours ago
//
//   [RK]  Rajesh Kumar
//         Renewed CrossFit Premium
//         3 hours ago
//
//   [VS]  Vikram Singh
//         Paid ₹10,000
//         5 hours ago
//
// HOW THE AVATAR INITIALS WORK:
//   The Flutter widget will split memberName by space and take
//   the first letter of each word. "Ananya Reddy" → "AR".
//   That's why the backend sends the full name, not initials.
// ═══════════════════════════════════════════════════════════════════

class RecentActivityItem {
  // ── Full name of the member this event belongs to ─────────────────
  // Example: "Ananya Reddy", "Rajesh Kumar"
  // Widget generates initials avatar from this (e.g. "AR", "RK")
  final String memberName;

  // ── Type of event — used by widget to pick icon and color ─────────
  // Possible values from backend (activityType field):
  //   "NEW_MEMBER"  → person-add icon, blue
  //   "RENEWAL"     → refresh icon, green
  //   "PAYMENT"     → rupee icon, purple
  //   "CHECKIN"     → check icon, orange
  final String activityType;

  // ── Human-readable description of what happened ───────────────────
  // Example: "Joined Premium Monthly", "Paid ₹10,000"
  final String description;

  // ── Relative time string, calculated by backend ──────────────────
  // Example: "2 hours ago", "3 minutes ago", "Yesterday"
  // Backend calculates this from the raw timestamp.
  final String timeAgo;

  const RecentActivityItem({
    required this.memberName,
    required this.activityType,
    required this.description,
    required this.timeAgo,
  });
}