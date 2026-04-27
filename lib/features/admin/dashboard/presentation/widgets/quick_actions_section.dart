/*
 * PURPOSE: Quick Actions Section Widget
 *
 * Displays a 2x2 grid of action buttons for common admin tasks:
 * - Add Member: Navigate to member registration form
 * - Record Payment: Quick payment entry for existing members
 * - Add Plan: Create new membership plans or packages
 * - Send Announcement: Broadcast messages to members
 *
 * DESIGN FEATURES:
 * - 2x2 grid layout for easy thumb access on mobile
 * - Each action has colored icon and descriptive label
 * - White container with rounded corners and shadow
 * - Responsive layout that adapts to screen width
 * - Icons use brand colors to differentiate actions visually
 *
 * USAGE:
 * Pass callback functions for each action button
 * In production, these would navigate to respective screens or show dialogs
 */

import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  // Callback functions for each action button
  final VoidCallback onAddMember;
  final VoidCallback onRecordPayment;
  final VoidCallback onAddPlan;
  final VoidCallback onSendAnnouncement;

  const QuickActionsSection({
    super.key,
    required this.onAddMember,
    required this.onRecordPayment,
    required this.onAddPlan,
    required this.onSendAnnouncement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          /*
           * 2x2 GRID LAYOUT
           *
           * First row: Add Member | Record Payment
           * Second row: Add Plan | Send Announcement
           *
           * Each button is wrapped in Expanded to ensure equal width
           * SizedBox provides horizontal spacing between columns
           */
          Column(
            children: [
              // First Row: Add Member and Record Payment
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.person_add,
                      iconColor: const Color(0xFF3B82F6), // Blue
                      label: 'Add Member',
                      onTap: onAddMember,
                    ),
                  ),
                  const SizedBox(width: 12), // Horizontal spacing between buttons
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.attach_money,
                      iconColor: const Color(0xFF22C55E), // Green
                      label: 'Record Payment',
                      onTap: onRecordPayment,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Vertical spacing between rows

              // Second Row: Add Plan and Send Announcement
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.credit_card,
                      iconColor: const Color(0xFFA855F7), // Purple
                      label: 'Add Plan',
                      onTap: onAddPlan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.send,
                      iconColor: const Color(0xFFF97316), // Orange
                      label: 'Send Announcement',
                      onTap: onSendAnnouncement,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
 * QUICK ACTION BUTTON COMPONENT
 *
 * Individual button widget used in the 2x2 grid
 *
 * DESIGN:
 * - Vertically stacked layout: icon on top, label below
 * - Circular colored icon background matching button's theme color
 * - Centered alignment for clean, balanced appearance
 * - Tap ripple effect for user feedback
 * - Padding for comfortable touch targets (minimum 48x48 dp)
 *
 * PARAMETERS:
 * - icon: Material icon to display
 * - iconColor: Background color for icon container (also used for icon itself)
 * - label: Text label displayed below icon
 * - onTap: Callback function executed when button is tapped
 */
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // Rounded ripple effect
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor, // Solid color background
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white, // White icon on colored background
                size: 24,
              ),
            ),
            const SizedBox(height: 8),

            // Action label text
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Allow text to wrap to second line if needed
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}