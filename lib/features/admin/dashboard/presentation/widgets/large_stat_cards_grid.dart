/*
 * PURPOSE: Large Stat Cards Grid Widget
 *
 * Displays the top 4 key performance indicators in a 2x2 grid layout:
 * Row 1: Active Members | Pending Renewals
 * Row 2: Today's Check-ins | Upcoming PT Sessions
 *
 * DESIGN FEATURES:
 * - Each card has a colored icon, title, large value, and growth/status indicator
 * - Icons use solid colored backgrounds (not light backgrounds like small cards)
 * - Responsive layout: cards automatically adjust width based on screen size
 * - Color coding: Blue (members), Orange (renewals), Green (checkins), Purple (PT)
 *
 * DATA SOURCE:
 * Receives AdminDashboardSummary entity containing:
 * - members.activeMembers, members.activeMembersGrowth
 * - members.pendingRenewals
 * - checkins.todayCheckins
 * - checkins.upcomingPTSessions
 *
 * RESPONSIVE BEHAVIOR:
 * - Cards expand/contract based on available screen width
 * - Maintains 12px spacing between cards
 * - Text sizes remain constant for readability
 */

import 'package:flutter/material.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

class LargeStatCardsGrid extends StatelessWidget {
  final AdminDashboardSummary data;

  const LargeStatCardsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FIRST ROW: Active Members and Pending Renewals
        Row(
          children: [
            // Active Members Card (Blue)
            Expanded(
              child: _LargeStatCard(
                iconColor: const Color(0xFF3B82F6), // Blue 500
                icon: Icons.group,
                value: '${data.members.activeMembers}',
                // Growth indicator: show + or - based on value
                sublabel: data.members.activeMembersGrowth >= 0
                    ? '+${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth'
                    : '${data.members.activeMembersGrowth.toStringAsFixed(0)}% growth',
                // Green for positive growth, Red for negative
                sublabelColor: data.members.activeMembersGrowth >= 0
                    ? const Color(0xFF22C55E) // Green 500
                    : const Color(0xFFEF4444), // Red 500
                title: 'Active Members',
              ),
            ),
            const SizedBox(width: 12), // Horizontal spacing

            // Pending Renewals Card (Orange)
            Expanded(
              child: _LargeStatCard(
                iconColor: const Color(0xFFF97316), // Orange 500
                icon: Icons.calendar_today,
                value: '${data.members.pendingRenewals}',
                sublabel: 'Due soon',
                sublabelColor: const Color(0xFFF97316), // Orange (urgent)
                title: 'Pending Renewals',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12), // Vertical spacing between rows

        // SECOND ROW: Today's Check-ins and Upcoming PT
        Row(
          children: [
            // Today's Check-ins Card (Green)
            Expanded(
              child: _LargeStatCard(
                iconColor: const Color(0xFF22C55E), // Green 500
                icon: Icons.how_to_reg,
                value: '${data.checkins.todayCheckins}',
                sublabel: 'Live now',
                sublabelColor: const Color(0xFF22C55E), // Green (active/live)
                title: "Today's Check-ins",
              ),
            ),
            const SizedBox(width: 12),

            // Upcoming PT Sessions Card (Purple)
            Expanded(
              child: _LargeStatCard(
                iconColor: const Color(0xFFA855F7), // Purple 500
                icon: Icons.fitness_center,
                value: '${data.checkins.upcomingPTSessions}',
                sublabel: 'Sessions',
                sublabelColor: const Color(0xFFA855F7), // Purple
                title: 'Upcoming PT',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/*
 * LARGE STAT CARD COMPONENT
 *
 * Individual card displaying a single key metric
 *
 * LAYOUT (top to bottom):
 * 1. Colored icon in square container (44x44)
 * 2. Small title text (e.g., "Active Members")
 * 3. Large value text (e.g., "247")
 * 4. Colored sublabel (e.g., "+12% growth")
 *
 * DESIGN DETAILS:
 * - White background with subtle shadow for depth
 * - Rounded corners (12px border radius)
 * - Icon has solid color background (matches iconColor)
 * - Value text is bold and large (28px) for emphasis
 * - Sublabel color indicates status (green=good, red=bad, orange=warning)
 *
 * PARAMETERS:
 * - iconColor: Background color for icon container
 * - icon: Material icon to display
 * - title: Small label above value (e.g., "Active Members")
 * - value: Large number to display (e.g., "247")
 * - sublabel: Small status text below value (e.g., "+12% growth")
 * - sublabelColor: Color for sublabel text (conveys meaning)
 */
class _LargeStatCard extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String value;
  final String title;
  final String sublabel;
  final Color sublabelColor;

  const _LargeStatCard({
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.title,
    required this.sublabel,
    required this.sublabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Subtle shadow for card elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2), // Slight downward shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left-align all content
        children: [
          // ICON CONTAINER
          // Square container with solid color background
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor, // Solid background (not light/transparent)
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white, // White icon on colored background
              size: 22,
            ),
          ),
          const SizedBox(height: 12),

          // TITLE TEXT
          // Small gray label identifying the metric
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),

          // VALUE TEXT
          // Large bold number - the main content of the card
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // SUBLABEL TEXT
          // Status indicator with semantic color
          // Examples: "+12% growth" (green), "Due soon" (orange), "Live now" (green)
          Text(
            sublabel,
            style: TextStyle(
              fontSize: 12,
              color: sublabelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}