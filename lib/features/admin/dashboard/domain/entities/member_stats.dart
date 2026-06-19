// ═══════════════════════════════════════════════════════════════════
// member_stats.dart  ─  DOMAIN ENTITY
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   Represents the 8 member-related numbers shown on the dashboard.
//   This entity lives in the DOMAIN layer — meaning it has ZERO
//   knowledge of JSON, HTTP, or Flutter UI.

// HOW IT FITS:
//   Backend Java DTO  →  (JSON)  →  MemberStatsModel (data layer)
//                                         ↓  .toEntity()
//                                   MemberStats  ← THIS FILE
//                                         ↓
//                                   BLoC state  →  UI widget
//
// WHY SEPARATE FROM MODEL?
//   The model (data layer) is tightly coupled to backend JSON keys.
//   If the backend renames "activeMembers" to "active_count", only
//   the model's fromJson changes — the entity and ALL UI code stay
//   untouched. Clean Architecture = isolate change.
// ═══════════════════════════════════════════════════════════════════

class MemberStats {
  // ── How many members have an ACTIVE membership right now ──────────
  // Shown in the "Active Members" large card. Example: 247
  final int activeMembers;

  // ── % growth vs same period last month ───────────────────────────
  // Shown as "+12% growth" badge under the active members count.
  // Positive = growing, negative = shrinking.
  final double activeMembersGrowth;

  // ── Total users with MEMBER role ever registered ──────────────────
  // Shown in the "Total Members" small card. Example: 4
  // Unlike activeMembers, this includes expired/cancelled members.
  final int totalMembers;

  // ── Memberships expiring in the next 3 days ───────────────────────
  // Shown in the "Pending Renewals" large card. Example: 12
  // These need urgent action — contact them or auto-renew.
  final int pendingRenewals;

  // ── Memberships expiring in the next 7 days ───────────────────────
  // Shown in the "Expiring Plans" small card. Example: 1
  // Broader view than pendingRenewals (3 days ⊂ 7 days).
  final int expiringPlansNext7Days;

  // ── Memberships CANCELLED in the last 7 days ─────────────────────
  // Shown in the "Canceled" text row. Example: 3
  // A spike here = investigate why members are leaving.
  final int canceledLast7Days;

  // ── Churn rate for the last 30 days ──────────────────────────────
  // Formula: (cancelled last 30d / active 30d ago) × 100
  // Shown as "1.2%" in the Churn Rate card.
  final double churnRate;

  // ── How churn changed vs the previous 30-day window ──────────────
  // Positive = churn got WORSE. Negative = churn IMPROVED.
  // Shown as "-0.3% vs last month" (green = improved).
  final double churnRateVsLastMonth;

  // ── Members whose date of birth is today (year-agnostic) ──────────
  final int birthdaysToday;

  // ── Active memberships ending today / in these day ranges ─────────
  final int expiringToday;
  final int expiring1to3Days;
  final int expiring4to7Days;
  final int expiring8to15Days;

  // ── Active PT packages ending today / in these day ranges ─────────
  final int ptExpiringToday;
  final int ptExpiring1to7Days;
  final int ptExpiring8to15Days;

  // Constructor — const makes instances immutable and compile-time safe
  const MemberStats({
    required this.activeMembers,
    required this.activeMembersGrowth,
    required this.totalMembers,
    required this.pendingRenewals,
    required this.expiringPlansNext7Days,
    required this.canceledLast7Days,
    required this.churnRate,
    required this.churnRateVsLastMonth,
    required this.birthdaysToday,
    required this.expiringToday,
    required this.expiring1to3Days,
    required this.expiring4to7Days,
    required this.expiring8to15Days,
    required this.ptExpiringToday,
    required this.ptExpiring1to7Days,
    required this.ptExpiring8to15Days,
  });
}