/*
 * PURPOSE: Small Metric Cards Grid Widget
 *
 * Displays secondary metrics in a 2x2 grid layout below the large stat cards:
 * Row 1: Attendance | Payments Collected
 * Row 2: Expiring Plans | Total Members
 *
 * DESIGN FEATURES:
 * - Smaller, more compact cards than LargeStatCardsGrid
 * - Icon backgrounds use light/transparent colors (12% opacity)
 * - Badge overlays in top-right corner for growth/status indicators
 * - Each card has icon, value, label, and optional sublabel
 *
 * DATA SOURCE:
 * Receives AdminDashboardSummary entity containing:
 * - checkins.attendanceCount, checkins.attendanceGrowth
 * - revenue.paymentsCollected, revenue.paymentsGrowth
 * - members.expiringPlansNext7Days
 * - members.totalMembers, members.activeMembers
 *
 * DESIGN DIFFERENCES VS LARGE CARDS:
 * - Icon background is light/transparent (not solid)
 * - Badge positioned absolutely in top-right corner
 * - Smaller overall height (more compact)
 * - Value text is slightly smaller (22px vs 28px)
 */

import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class SmallMetricCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;

  const SmallMetricCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FIRST ROW: Attendance and Payments Collected
        Row(
          children: [
            // Attendance Card (Blue)
            Expanded(
              child: _SmallMetricCard(
                icon: Icons.directions_run,
                iconColor: const Color(0xFF3B82F6), // Blue 500
                value: '${data.checkins.attendanceCount}',
                label: 'Attendance',
                // Badge shows growth percentage in green
                badge: '+${data.checkins.attendanceGrowth.toStringAsFixed(0)}%',
              ),
            ),
            const SizedBox(width: 12), // Horizontal spacing

            // Payments Collected Card (Green)
            Expanded(
              child: _SmallMetricCard(
                icon: Icons.attach_money,
                iconColor: const Color(0xFF22C55E), // Green 500
                // Display currency symbol and amount, or N/A if no revenue data
                value: data.revenue != null
                    ? '₹${data.revenue!.paymentsCollected.toStringAsFixed(0)}'
                    : 'N/A',
                label: 'Payments Collected',
                // Show growth badge only if revenue data exists
                badge: data.revenue != null
                    ? '+${data.revenue!.paymentsGrowth.toStringAsFixed(0)}%'
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12), // Vertical spacing between rows

        // SECOND ROW: Expiring Plans and Total Members
        Row(
          children: [
            // Expiring Plans Card (Orange)
            Expanded(
              child: _SmallMetricCard(
                icon: Icons.calendar_month,
                iconColor: const Color(0xFFF97316), // Orange 500
                value: '${data.members.expiringPlansNext7Days}',
                label: 'Expiring Plans',
                sublabel: 'Next 7 days', // Clarifies time window
              ),
            ),
            const SizedBox(width: 12),

            // Total Members Card (Purple)
            Expanded(
              child: _SmallMetricCard(
                icon: Icons.people,
                iconColor: const Color(0xFFA855F7), // Purple 500
                value: '${data.members.totalMembers}',
                label: 'Total Members',
                // Badge shows active members count
                badge: '~${data.members.activeMembers} Active',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/*
 * SMALL METRIC CARD COMPONENT
 *
 * Individual compact card displaying a secondary metric
 *
 * LAYOUT (top to bottom):
 * 1. Icon in light colored square (36x36) - with badge in corner if provided
 * 2. Large value text (22px)
 * 3. Small label text (11px)
 * 4. Optional sublabel text (10px) - for additional context
 *
 * DESIGN DETAILS:
 * - White background with subtle shadow
 * - Icon background uses 12% opacity of iconColor (light/transparent)
 * - Badge positioned absolutely in top-right corner
 * - More compact than large stat cards
 *
 * BADGE POSITIONING:
 * - Uses Stack widget to overlay badge on top of card content
 * - Badge appears in top-right corner (8px from edges)
 * - Badge has green background with white text
 * - Badge is optional (null = no badge displayed)
 *
 * PARAMETERS:
 * - icon: Material icon to display
 * - iconColor: Color for icon and its light background
 * - value: Main metric value (e.g., "2", "₹21,000", "4")
 * - label: Description of metric (e.g., "Attendance")
 * - badge: Optional badge text (e.g., "+12%", "3 Active")
 * - sublabel: Optional additional context (e.g., "Next 7 days")
 */
class _SmallMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? badge;
  final String? sublabel;

  const _SmallMetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.badge,
    this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    // Stack allows badge to overlay in corner
    return Stack(
      children: [
        // MAIN CARD CONTAINER
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON CONTAINER
              // Light background (12% opacity) instead of solid color
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12), // Light/transparent background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor, // Solid color icon
                  size: 18,
                ),
              ),
              const SizedBox(height: 10),

              // VALUE TEXT
              // Main metric number
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),

              // LABEL TEXT
              // Description of what the value represents
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black45,
                ),
              ),

              // OPTIONAL SUBLABEL
              // Additional context (e.g., "Next 7 days")
              if (sublabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  sublabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                  ),
                ),
              ],
            ],
          ),
        ),

        // OPTIONAL BADGE OVERLAY
        // Positioned absolutely in top-right corner
        if (badge != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E), // Green background
                borderRadius: BorderRadius.circular(10), // Pill shape
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}