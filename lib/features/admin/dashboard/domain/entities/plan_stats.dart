// ═══════════════════════════════════════════════════════════════════
// plan_stats.dart  ─  DOMAIN ENTITY
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   Represents counts of gym PLANS (the products the gym sells),
//   NOT individual member memberships.
//
//   PLAN     = a product definition, e.g. "Monthly Premium – ₹2000"
//   MEMBERSHIP = a specific member's subscription to a plan
//
//   The backend PlanStatsService queries the membership_plan table,
//   which stores plan templates. This entity carries those counts.
//
// SHOWN IN UI:
//   "Total Plans  6"  with "6 Active" underneath
//   "Canceled     3"  ← note: this is canceledLast7Days from MemberStats,
//                        NOT from PlanStats. PlanStats has expiredPlans.
// ═══════════════════════════════════════════════════════════════════

class PlanStats {
  // ── Total plan products this gym has ever created ─────────────────
  // Shown in "Total Plans" card. Example: 6
  // Includes both active (still being sold) and inactive (discontinued).
  final int totalPlans;

  // ── Plans currently available for new memberships ─────────────────
  // Shown as "6 Active" subtitle. Example: 6
  // isActive = true in the membership_plan table.
  final int activePlans;

  // ── Plans that have been discontinued ────────────────────────────
  // = totalPlans − activePlans (no separate DB column for this)
  // A plan is "expired" simply because the gym deactivated it.
  final int expiredPlans;

  const PlanStats({
    required this.totalPlans,
    required this.activePlans,
    required this.expiredPlans,
  });
}