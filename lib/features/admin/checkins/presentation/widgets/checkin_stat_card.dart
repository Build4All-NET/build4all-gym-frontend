// =============================================================================
// FILE: checkin_stat_card.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkin_stat_card.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   A single colored stat card (Active Now / Total Today).
//   Extracted so it can be reused independently and tested in isolation.
// =============================================================================

import 'package:flutter/material.dart';

class CheckinStatCard extends StatelessWidget {
  const CheckinStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.tintColor,   // background tint (low opacity)
    required this.iconColor,   // icon + number color
    this.isLoading = false,
  });

  final IconData icon;
  final int      value;
  final String   label;
  final Color    tintColor;
  final Color    iconColor;
  final bool     isLoading;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          // Soft tinted background — 15% opacity feels like the design spec.
          color:        tintColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? _Skeleton()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize:   28,
                fontWeight: FontWeight.w700,
                color:      iconColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w500,
                color:      iconColor.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton placeholder shown while loading ──────────────────────────────────
class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Bar(width: 26, height: 26, radius: 6),
        const SizedBox(height: 10),
        _Bar(width: 48, height: 28, radius: 6),
        const SizedBox(height: 6),
        _Bar(width: 72, height: 14, radius: 4),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Bar({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  width,
      height: height,
      decoration: BoxDecoration(
        color:        Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
