// =============================================================================
// FILE: ai_assistant_repository.dart
// PATH: lib/features/owner/ai_assistant/domain/repositories/ai_assistant_repository.dart
// LAYER: Domain Layer → Repositories (Abstract Contract)
// =============================================================================
// Defines WHAT the AI assistant feature can do — not HOW.
//
// The domain layer only depends on this abstract class.
// The concrete implementation (AiAssistantRepositoryImpl) lives in the data
// layer and does the actual HTTP calls + model-to-entity mapping.
//
// This separation means the BLoC/use-cases can be tested without a real server.
// =============================================================================

import '../entities/ai_query_history_entity.dart';
import '../entities/ai_stat_card_entity.dart';
import '../entities/ai_message_entity.dart';
import '../entities/suggested_question_entity.dart';

/// The result of an AI query call — returned to the BLoC by the use case.
///
/// A successful HTTP response does not guarantee a real AI answer: the
/// backend always returns HTTP 200, even when the provider is disabled,
/// misconfigured, or timed out. Callers must check [dataAvailable] before
/// treating [answer] as genuine AI output.
class AiQueryResult {
  final String              answer;            // the AI's natural-language answer
  final List<AiStatCardEntity> statCards;      // metric cards (may be empty)
  final List<String>        suggestedFollowUps; // follow-up chip questions (≤3)
  final bool                dataAvailable;      // false = answer is not a real AI response
  final String?             errorCode;          // stable code when dataAvailable is false

  const AiQueryResult({
    required this.answer,
    required this.statCards,
    required this.suggestedFollowUps,
    this.dataAvailable = true,
    this.errorCode,
  });
}

abstract class AiAssistantRepository {

  // ── POST /api/owner/ai-assistant/query ────────────────────────────────────
  // Sends the owner's query + conversation history to the backend, which calls
  // the Claude API and returns a structured JSON answer.
  Future<AiQueryResult> sendQuery({
    required String                query,
    required List<AiMessageEntity> conversationHistory,
  });

  // ── GET /api/owner/ai-assistant/suggestions ───────────────────────────────
  // Returns the 5 hardcoded suggested starter questions from the backend.
  Future<List<SuggestedQuestionEntity>> getSuggestedQuestions();

  // ── GET /api/owner/ai-assistant/history ───────────────────────────────────
  // Returns the last 10 queries this owner has made.
  Future<List<AiQueryHistoryEntity>> getRecentQueries();
}