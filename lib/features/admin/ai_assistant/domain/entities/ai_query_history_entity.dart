// =============================================================================
// FILE: ai_query_history_entity.dart
// PATH: lib/features/owner/ai_assistant/domain/entities/ai_query_history_entity.dart
// LAYER: Domain Layer → Entities
// =============================================================================
// One past question + answer pair shown in the "Recent Queries" list.
//
// Returned by GET /api/owner/ai-assistant/history (last 10 interactions).
// The owner can tap any item to re-submit that question.
// =============================================================================

class AiQueryHistoryEntity {
  final int    id;              // DB row id — not shown in UI but useful for keying
  final String queryText;       // the question the owner asked
  final String responseAnswer;  // the AI's answer at the time
  final String createdAt;       // ISO-8601 timestamp string from the backend

  const AiQueryHistoryEntity({
    required this.id,
    required this.queryText,
    required this.responseAnswer,
    required this.createdAt,
  });
}