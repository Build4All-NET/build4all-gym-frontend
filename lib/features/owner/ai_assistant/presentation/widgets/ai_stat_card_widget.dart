// =============================================================================
// FILE: ai_stat_card_widget.dart
// PATH: lib/features/owner/ai_assistant/presentation/widgets/ai_stat_card_widget.dart
// LAYER: Presentation Layer → Widgets
// =============================================================================
// Renders a single metric card shown below the AI's text answer.
// Displays icon, label, value, and an optional trend badge.
// Green badge for positive trends (+), red for negative (-).
// =============================================================================

import 'package:flutter/material.dart';
import '../../domain/entities/ai_stat_card_entity.dart';

class AiStatCardWidget extends StatelessWidget {
  final AiStatCardEntity card;

  const AiStatCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          // Icon + trend badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconWidget(card.icon),
              if (card.hasTrend) _trendBadge(card.trend!, card.isPositiveTrend),
            ],
          ),
          const SizedBox(height: 10),
          // Value (large)
          Text(
            card.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // Label
          Text(
            card.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Maps the icon key string to an IconData.
  // Add more mappings as needed when the AI starts returning new icon keys.
  Widget _iconWidget(String iconKey) {
    final IconData icon;
    switch (iconKey) {
      case 'revenue_growth':  icon = Icons.trending_up;         break;
      case 'active_members':  icon = Icons.people_alt_outlined;  break;
      case 'checkins_today':  icon = Icons.login_outlined;       break;
      case 'popular_plan':    icon = Icons.star_outline;         break;
      case 'top_trainer':     icon = Icons.fitness_center;       break;
      default:                icon = Icons.bar_chart_outlined;   break;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
    );
  }

  Widget _trendBadge(String trend, bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        trend,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
    );
  }
}