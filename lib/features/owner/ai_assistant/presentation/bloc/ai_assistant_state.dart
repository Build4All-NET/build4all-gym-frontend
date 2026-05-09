part of 'ai_assistant_bloc.dart';

// =============================================================================
// FILE: ai_assistant_state.dart
// PATH: lib/features/owner/ai_assistant/presentation/bloc/ai_assistant_state.dart
// LAYER: Presentation Layer → BLoC States
// =============================================================================
// All states the AiAssistantBloc can emit.
//
// SCREEN LIFECYCLE:
//   AiAssistantInitial        → before anything loads
//   AiAssistantLoading        → loading suggestions + history on startup
//   AiAssistantReady          → start screen: suggestions + history visible
//   AiAssistantQuerying       → owner submitted a question, waiting for AI
//   AiAssistantAnswered       → AI responded — show conversation + stat cards
//   AiAssistantError          → something failed at the startup/load level
// =============================================================================

abstract class AiAssistantState {
  const AiAssistantState();
}

/// Before the screen has loaded anything.
class AiAssistantInitial extends AiAssistantState {
  const AiAssistantInitial();
}

/// Loading suggestions and recent history on screen open.
class AiAssistantLoading extends AiAssistantState {
  const AiAssistantLoading();
}

/// Start screen: suggestions + recent queries loaded, no conversation yet.
class AiAssistantReady extends AiAssistantState {
  final List<SuggestedQuestionEntity> suggestions;  // 5 chips
  final List<AiQueryHistoryEntity>    recentQueries; // up to 10

  const AiAssistantReady({
    required this.suggestions,
    required this.recentQueries,
  });
}

/// Owner submitted a query — waiting for the AI to respond.
/// We keep the conversation so the screen can show a loading indicator
/// within the chat while preserving previous messages.
class AiAssistantQuerying extends AiAssistantState {
  final AiConversationEntity conversation; // messages so far (before AI reply)

  const AiAssistantQuerying({required this.conversation});
}

/// AI responded successfully.
/// Contains the full conversation (with the new AI reply appended),
/// stat cards, and follow-up suggestions.
class AiAssistantAnswered extends AiAssistantState {
  final AiConversationEntity   conversation;       // all messages incl. new reply
  final List<AiStatCardEntity> statCards;          // metric cards from this answer
  final List<String>           suggestedFollowUps; // 2-3 follow-up chips

  const AiAssistantAnswered({
    required this.conversation,
    required this.statCards,
    required this.suggestedFollowUps,
  });
}

/// A load/query error occurred. message shown in the UI.
class AiAssistantError extends AiAssistantState {
  final String message;

  const AiAssistantError(this.message);
}