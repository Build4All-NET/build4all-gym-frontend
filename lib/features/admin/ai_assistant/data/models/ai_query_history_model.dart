// =============================================================================
// FILE: ai_query_history_model.dart
// PATH: lib/features/owner/ai_assistant/data/models/ai_query_history_model.dart
// LAYER: Data Layer → Models
// =============================================================================
// Deserialises one entry from GET /api/owner/ai-assistant/history.
//
// Backend AiQueryHistoryDto.java shape:
//   {
//     "id": 42,
//     "queryText": "What is my revenue this month?",
//     "responseAnswer": "Your revenue this month is $4,200...",
//     "createdAt": "2025-05-07T10:23:45"
//   }
//
// createdAt comes as a LocalDateTime string — we keep it as a String here
// so the widget can format it however it needs (e.g. "3 minutes ago").
// =============================================================================

import '../../domain/entities/ai_query_history_entity.dart';

class AiQueryHistoryModel {
  final int    id;
  final String queryText;
  final String responseAnswer;
  final String createdAt;  // ISO-8601 e.g. "2025-05-07T10:23:45"

  const AiQueryHistoryModel({
    required this.id,
    required this.queryText,
    required this.responseAnswer,
    required this.createdAt,
  });

  // ── Deserialise from the backend JSON ─────────────────────────────────────
  factory AiQueryHistoryModel.fromJson(Map<String, dynamic> json) {
    return AiQueryHistoryModel(
      id:             json['id']             as int,
      queryText:      json['queryText']      as String? ?? '',
      responseAnswer: json['responseAnswer'] as String? ?? '',
      createdAt:      json['createdAt']      as String? ?? '',
    );
  }

  // ── Map to the pure domain entity ─────────────────────────────────────────
  AiQueryHistoryEntity toEntity() {
    return AiQueryHistoryEntity(
      id:             id,
      queryText:      queryText,
      responseAnswer: responseAnswer,
      createdAt:      createdAt,
    );
  }
}