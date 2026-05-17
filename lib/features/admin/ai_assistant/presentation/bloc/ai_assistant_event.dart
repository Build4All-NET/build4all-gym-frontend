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
part of 'ai_assistant_bloc.dart';

// =============================================================================
// FILE: ai_assistant_event.dart
// =============================================================================

abstract class AiAssistantEvent {
  const AiAssistantEvent();
}

class AiAssistantStarted extends AiAssistantEvent {
  const AiAssistantStarted();
}

/// [errorFallbackMessage] — the localised "sorry, couldn't process" string,
/// passed from the screen so the BLoC stays context-free.
class AiQuerySubmitted extends AiAssistantEvent {
  final String                query;
  final List<AiMessageEntity> conversationHistory;
  final String                errorFallbackMessage;

  const AiQuerySubmitted({
    required this.query,
    required this.conversationHistory,
    required this.errorFallbackMessage,
  });
}

class AiSuggestionTapped extends AiAssistantEvent {
  final String question;
  final String errorFallbackMessage;

  const AiSuggestionTapped(this.question, {required this.errorFallbackMessage});
}

class AiHistoryItemTapped extends AiAssistantEvent {
  final String queryText;
  final String errorFallbackMessage;

  const AiHistoryItemTapped(this.queryText, {required this.errorFallbackMessage});
}

class AiConversationReset extends AiAssistantEvent {
  const AiConversationReset();
}