/*
 * PURPOSE: Text Metric Rows Widget
 *
 * Displays additional dashboard metrics in a simple list format:
 * - Total Plans (with active count)
 * - Canceled members (last 7 days)
 * - Churn Rate (with vs last month comparison)
 * - Monthly Revenue (with vs last month comparison)
 *
 * DESIGN FEATURES:
 * - Simple horizontal layout: label on left, value on right
 * - Colored dot indicator for visual categorization
 * - Sublabel shows trend comparison (vs last month)
 * - White background cards with minimal spacing
 *
 * DATA SOURCE:
 * Receives AdminDashboardSummary entity containing:
 * - plans.totalPlans, plans.activePlans
 * - members.canceledLast7Days
 * - members.churnRate, members.churnRateVsLastMonth
 * - revenue.monthlyRevenue, revenue.monthlyRevenueVsLastMonth
 *
 * DESIGN RATIONALE:
 * These metrics are less critical than the large/small cards above
 * Simple text rows provide information without overwhelming the user
 * Useful for admins who need detailed financial/operational data
 */

import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class TextMetricRows extends StatelessWidget {
  final AdminDashboardSummary data;

  const TextMetricRows({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Extract comparison values for cleaner code
    final churnVsLast = data.members.churnRateVsLastMonth;
    final revenueVsLast = data.revenue?.monthlyRevenueVsLastMonth;

    return Column(
      children: [
        // TOTAL PLANS ROW
        _TextMetricRow(
          label: 'Total Plans',
          value: '${data.plans.totalPlans}',
          dotColor: const Color(0xFF3B82F6), // Blue dot
          sublabel: '${data.plans.activePlans} Active',
          sublabelColor: const Color(0xFF3B82F6), // Blue (informational)
        ),
        const SizedBox(height: 10),

        // CANCELED MEMBERS ROW
        _TextMetricRow(
          label: 'Canceled',
          value: '${data.members.canceledLast7Days}',
          dotColor: const Color(0xFFEF4444), // Red dot (negative metric)
          sublabel: 'Last 7 days',
          sublabelColor: Colors.black45, // Gray (neutral)
        ),
        const SizedBox(height: 10),

        // CHURN RATE ROW
        _TextMetricRow(
          label: 'Churn Rate',
          value: '${data.members.churnRate.toStringAsFixed(1)}%',
          dotColor: const Color(0xFF22C55E), // Green dot
          // Show trend: negative change is good (decreasing churn)
          sublabel: churnVsLast <= 0
              ? '${churnVsLast.toStringAsFixed(1)}% vs last month'
              : '+${churnVsLast.toStringAsFixed(1)}% vs last month',
          // Green if churn decreased, Red if increased
          sublabelColor: churnVsLast <= 0
              ? const Color(0xFF22C55E) // Green (good - churn decreased)
              : const Color(0xFFEF4444), // Red (bad - churn increased)
        ),
        const SizedBox(height: 10),

        // MONTHLY REVENUE ROW
        _TextMetricRow(
          label: 'Monthly Revenue',
          // Convert to Lakhs (L) for Indian currency format
          // 100,000 = 1L, so divide by 100,000
          value: data.revenue != null
              ? '₹${(data.revenue!.monthlyRevenue / 100000).toStringAsFixed(1)}L'
              : 'N/A',
          dotColor: const Color(0xFFA855F7), // Purple dot
          // Show growth percentage if revenue data exists
          sublabel: revenueVsLast != null
              ? '+${revenueVsLast.toStringAsFixed(0)}% vs last month'
              : null,
          sublabelColor: const Color(0xFF22C55E), // Green (growth is good)
        ),
      ],
    );
  }
}

/*
 * TEXT METRIC ROW COMPONENT
 *
 * Individual row displaying a metric in horizontal layout
 *
 * LAYOUT:
 * Left side: Label (small) + Value (large)
 * Right side: Colored dot + Optional sublabel
 *
 * DESIGN DETAILS:
 * - White background with rounded corners
 * - Subtle shadow for depth
 * - SpaceBetween alignment pushes left and right content to edges
 * - Colored dot provides visual categorization
 *
 * PARAMETERS:
 * - label: Metric name (e.g., "Total Plans", "Churn Rate")
 * - value: Metric value (e.g., "6", "1.2%", "₹12.5L")
 * - dotColor: Color of indicator dot (semantic color)
 * - sublabel: Optional additional info (e.g., "6 Active", "+15% vs last month")
 * - sublabelColor: Color of sublabel text (indicates good/bad/neutral)
 *
 * COLOR SEMANTICS:
 * - Blue: Informational/neutral metrics
 * - Green: Positive metrics or good trends
 * - Red: Negative metrics or concerning trends
 * - Purple: Financial/revenue metrics
 * - Orange: Warning/attention needed
 */
class _TextMetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final String? sublabel;
  final Color sublabelColor;

  const _TextMetricRow({
    required this.label,
    required this.value,
    required this.dotColor,
    this.sublabel,
    required this.sublabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push content to edges
        children: [
          // LEFT SIDE: Label and Value stacked vertically
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LABEL TEXT
              // Small gray text identifying the metric
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 4),

              // VALUE TEXT
              // Large bold number - the main content
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          // RIGHT SIDE: Colored dot and optional sublabel stacked vertically
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // COLORED DOT INDICATOR
              // Small circle for visual categorization
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),

              // OPTIONAL SUBLABEL
              // Additional context or trend information
              if (sublabel != null) ...[
                const SizedBox(height: 6),
                Text(
                  sublabel!,
                  style: TextStyle(
                    fontSize: 11,
                    color: sublabelColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}