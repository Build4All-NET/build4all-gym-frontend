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

/// [errorFallbackMessage] — the localised "sorry, couldn't process" string
/// shown when the query call itself fails (network/auth/server error).
///
/// [translateErrorCode] — translates a stable backend `errorCode` (e.g.
/// `AI_PROVIDER_DISABLED`) into a localized message, used when the call
/// succeeds but the backend reports `dataAvailable: false` (provider
/// disabled, timeout, missing context, invalid response). Both are passed
/// from the screen so the BLoC stays context-free.
class AiQuerySubmitted extends AiAssistantEvent {
  final String                          query;
  final List<AiMessageEntity>           conversationHistory;
  final String                          errorFallbackMessage;
  final String Function(String? code)   translateErrorCode;

  const AiQuerySubmitted({
    required this.query,
    required this.conversationHistory,
    required this.errorFallbackMessage,
    required this.translateErrorCode,
  });
}

class AiSuggestionTapped extends AiAssistantEvent {
  final String                        question;
  final String                        errorFallbackMessage;
  final String Function(String? code) translateErrorCode;

  const AiSuggestionTapped(
    this.question, {
    required this.errorFallbackMessage,
    required this.translateErrorCode,
  });
}

class AiHistoryItemTapped extends AiAssistantEvent {
  final String                        queryText;
  final String                        errorFallbackMessage;
  final String Function(String? code) translateErrorCode;

  const AiHistoryItemTapped(
    this.queryText, {
    required this.errorFallbackMessage,
    required this.translateErrorCode,
  });
}

class AiConversationReset extends AiAssistantEvent {
  const AiConversationReset();
}