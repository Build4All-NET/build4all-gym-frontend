// =============================================================================
// FILE: ai_stat_card_model.dart
// PATH: lib/features/owner/ai_assistant/data/models/ai_stat_card_model.dart
// LAYER: Data Layer → Models
// =============================================================================
// Matches the backend AiStatCardDto shape:
//   { "icon": "revenue_growth", "label": "Monthly Revenue",
//     "value": "$4,200", "trend": "+15%" }
//
// trend is nullable — the backend omits it or sends null when not applicable.
// =============================================================================

import '../../domain/entities/ai_stat_card_entity.dart';

class AiStatCardModel {
  final String  icon;
  final String  label;
  final String  value;
  final String? trend;  // nullable — no trend badge when null

  const AiStatCardModel({
    required this.icon,
    required this.label,
    required this.value,
    this.trend,
  });

  // ── Deserialise from the backend JSON ─────────────────────────────────────
  factory AiStatCardModel.fromJson(Map<String, dynamic> json) {
    return AiStatCardModel(
      icon:  json['icon']  as String? ?? '',
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      trend: json['trend'] as String?, // keep null if absent/null
    );
  }

  // ── Map to the pure domain entity ─────────────────────────────────────────
  AiStatCardEntity toEntity() {
    return AiStatCardEntity(
      icon:  icon,
      label: label,
      value: value,
      trend: trend,
    );
  }
}