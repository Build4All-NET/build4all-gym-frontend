part of 'ai_assistant_bloc.dart';

// =============================================================================
// FILE: ai_assistant_event.dart
// PATH: lib/features/owner/ai_assistant/presentation/bloc/ai_assistant_event.dart
// LAYER: Presentation Layer → BLoC Events
// =============================================================================
// All events the AiAssistantBloc can receive.
//
// AiAssistantStarted   → screen opens: load suggestions + recent queries
// AiQuerySubmitted     → owner submits a question (typed or from suggestion chip)
// AiSuggestionTapped   → owner taps a suggestion chip (same as submitting)
// AiHistoryItemTapped  → owner taps a recent query to re-submit it
// AiConversationReset  → owner clears the chat to start fresh
// =============================================================================

abstract class AiAssistantEvent {
  const AiAssistantEvent();
}

/// Dispatched when the AI assistant screen is first opened.
/// Triggers loading of suggestions and recent query history.
class AiAssistantStarted extends AiAssistantEvent {
  const AiAssistantStarted();
}

/// Dispatched when the owner submits a new question.
/// [query] is the text the owner typed or selected from a suggestion chip.
/// [conversationHistory] is the current session's messages before this query.
class AiQuerySubmitted extends AiAssistantEvent {
  final String                query;
  final List<AiMessageEntity> conversationHistory;

  const AiQuerySubmitted({
    required this.query,
    required this.conversationHistory,
  });
}

/// Dispatched when the owner taps a suggestion chip.
/// Equivalent to AiQuerySubmitted with an empty conversation history
/// (suggestions are always used at the start of a conversation).
class AiSuggestionTapped extends AiAssistantEvent {
  final String question;

  const AiSuggestionTapped(this.question);
}

/// Dispatched when the owner taps an item in the Recent Queries list.
/// Re-submits that question as a fresh query (empty history).
class AiHistoryItemTapped extends AiAssistantEvent {
  final String queryText;

  const AiHistoryItemTapped(this.queryText);
}

/// Dispatched when the owner wants to clear the conversation and start over.
/// The BLoC resets to AiAssistantReady with the original suggestions.
class AiConversationReset extends AiAssistantEvent {
  const AiConversationReset();
}