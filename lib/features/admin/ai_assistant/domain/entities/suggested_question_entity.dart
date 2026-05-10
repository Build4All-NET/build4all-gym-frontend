// =============================================================================
// FILE: suggested_question_entity.dart
// PATH: lib/features/owner/ai_assistant/domain/entities/suggested_question_entity.dart
// LAYER: Domain Layer → Entities
// =============================================================================
// A single pre-defined question shown as a tappable chip on the AI screen
// before the owner has typed anything (the "empty state" / start screen).
//
// Returned by GET /api/owner/ai-assistant/suggestions (5 hardcoded questions).
// Tapping one pre-fills the query text field and auto-submits.
// =============================================================================

class SuggestedQuestionEntity {
  final String question; // e.g. "What's my revenue today?"

  const SuggestedQuestionEntity({required this.question});
}