// ═══════════════════════════════════════════════════════════════════
// revenue.dart  ─  DOMAIN ENTITY
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   Represents financial stats shown ONLY to OWNER role users.
//   The backend sends revenue=null when the logged-in user is ADMIN.
//   The entity itself is never null — but the AdminDashboardSummary
//   holds a nullable Revenue? field.
// SHOWN IN UI :
//   "₹21,000  Payments Collected  +8%"
//   "₹12.5L   Monthly Revenue    +15% vs last month"
// ═══════════════════════════════════════════════════════════════════

class Revenue {
  // ── Total payments collected during the selected period ───────────
  // period=today → today's collections
  // period=week  → last 7 days collections
  // Shown as "₹21,000" in the Payments Collected small card.
  final double paymentsCollected;

  // ── % growth in payments vs previous same-length period ──────────
  // Shown as "+8%" badge. Positive = more money collected.
  final double paymentsGrowth;

  // ── Total revenue for the current calendar month ──────────────────
  // Always the calendar month, NOT affected by the period dropdown.
  // Shown as "₹12.5L" in the Monthly Revenue text row.
  final double monthlyRevenue;

  // ── % change vs last calendar month's total revenue ──────────────
  // Shown as "+15% vs last month" (green = growing).
  final double monthlyRevenueVsLastMonth;

  // ── Outstanding (unpaid/partial/overdue) amount on membership invoices ──
  final double membershipDue;

  // ── Outstanding (unpaid/partial/overdue) amount on PT invoices ────────
  final double ptDue;

  // ── Total operating expenses logged for the current calendar month ────
  final double monthlyExpense;

  const Revenue({
    required this.paymentsCollected,
    required this.paymentsGrowth,
    required this.monthlyRevenue,
    required this.monthlyRevenueVsLastMonth,
    required this.membershipDue,
    required this.ptDue,
    required this.monthlyExpense,
  });
}