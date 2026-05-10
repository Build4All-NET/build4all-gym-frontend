// =============================================================================
// FILE: ai_stat_card_entity.dart
// PATH: lib/features/owner/ai_assistant/domain/entities/ai_stat_card_entity.dart
// LAYER: Domain Layer → Entities
// =============================================================================
// A single metric card shown below the AI's text answer.
//
// The AI populates a list of these when its answer contains numeric data.
// Example: when the owner asks about revenue, the AI returns:
//   icon  = "revenue_growth"
//   label = "Monthly Revenue"
//   value = "$4,200"
//   trend = "+15%"           ← null when no trend applies
//
// AiStatCardWidget maps icon → local icon asset and trend → colored badge.
// =============================================================================

class AiStatCardEntity {
  final String  icon;    // key string, e.g. "revenue_growth", "active_members"
  final String  label;   // human-readable label, e.g. "Monthly Revenue"
  final String  value;   // formatted value, e.g. "$4,200" or "342"
  final String? trend;   // optional, e.g. "+15%" | "-3%" | null

  const AiStatCardEntity({
    required this.icon,
    required this.label,
    required this.value,
    this.trend,
  });

  /// True when a trend badge should be shown on the card.
  bool get hasTrend => trend != null && trend!.isNotEmpty;

  /// True when the trend is positive (starts with '+').
  bool get isPositiveTrend => hasTrend && trend!.startsWith('+');
}