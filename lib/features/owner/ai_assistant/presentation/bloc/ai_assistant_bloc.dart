// =============================================================================
// FILE: ai_assistant_bloc.dart
// PATH: lib/features/owner/ai_assistant/presentation/bloc/ai_assistant_bloc.dart
// LAYER: Presentation Layer → BLoC
// =============================================================================
// Orchestrates the AI assistant feature. Handles all events and emits states
// that the screen and widgets react to.
//
// Use cases injected:
//   SendAiQueryUseCase            → for POST /query
//   GetSuggestedQuestionsUseCase  → for GET /suggestions
//   GetRecentQueriesUseCase       → for GET /history
//
// Conversation state is kept IN the BLoC (not persisted). It resets when the
// owner leaves the screen (BLoC is closed by BlocProvider).
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ai_conversation_entity.dart';
import '../../domain/entities/ai_message_entity.dart';
import '../../domain/entities/ai_query_history_entity.dart';
import '../../domain/entities/ai_stat_card_entity.dart';
import '../../domain/entities/suggested_question_entity.dart';
import '../../domain/usecases/get_recent_queries_usecase.dart';
import '../../domain/usecases/get_suggested_questions_usecase.dart';
import '../../domain/usecases/send_ai_query_usecase.dart';

part 'ai_assistant_event.dart';
part 'ai_assistant_state.dart';

class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  final SendAiQueryUseCase           sendAiQueryUseCase;
  final GetSuggestedQuestionsUseCase getSuggestedQuestionsUseCase;
  final GetRecentQueriesUseCase      getRecentQueriesUseCase;

  /// In-memory conversation for the current session.
  /// Starts empty, grows as the owner asks questions and the AI answers.
  AiConversationEntity _conversation = const AiConversationEntity();

  /// Cached suggestions so we can restore them on reset without a new API call.
  List<SuggestedQuestionEntity> _cachedSuggestions = [];

  AiAssistantBloc({
    required this.sendAiQueryUseCase,
    required this.getSuggestedQuestionsUseCase,
    required this.getRecentQueriesUseCase,
  }) : super(const AiAssistantInitial()) {
    on<AiAssistantStarted>(_onStarted);
    on<AiQuerySubmitted>(_onQuerySubmitted);
    on<AiSuggestionTapped>(_onSuggestionTapped);
    on<AiHistoryItemTapped>(_onHistoryItemTapped);
    on<AiConversationReset>(_onReset);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // _onStarted — AiAssistantStarted
  // ─────────────────────────────────────────────────────────────────────────
  // Loads suggestions and recent history in parallel (both are independent).
  // Even if history fails, we still show suggestions.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _onStarted(
      AiAssistantStarted event, Emitter<AiAssistantState> emit) async {
    emit(const AiAssistantLoading());

    try {
      // Run both API calls in parallel for faster screen load
      final results = await Future.wait([
        getSuggestedQuestionsUseCase(),
        getRecentQueriesUseCase(),
      ]);

      _cachedSuggestions = results[0] as List<SuggestedQuestionEntity>;
      final recentQueries = results[1] as List<AiQueryHistoryEntity>;

      emit(AiAssistantReady(
        suggestions:   _cachedSuggestions,
        recentQueries: recentQueries,
      ));
    } catch (e) {
      emit(AiAssistantError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // _onQuerySubmitted — AiQuerySubmitted
  // ─────────────────────────────────────────────────────────────────────────
  // Core query flow:
  //   1. Append the owner's message to conversation
  //   2. Emit AiAssistantQuerying (shows loading in chat)
  //   3. Call the AI use case
  //   4. Append the AI's reply to conversation
  //   5. Emit AiAssistantAnswered with stat cards + follow-ups
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _onQuerySubmitted(
      AiQuerySubmitted event, Emitter<AiAssistantState> emit) async {

    // Step 1: Append the owner's new message to the in-memory conversation
    _conversation = _conversation.withMessage(
      AiMessageEntity(role: 'user', content: event.query),
    );

    // Step 2: Show the loading state with the updated conversation
    emit(AiAssistantQuerying(conversation: _conversation));

    try {
      // Step 3: Call the AI — pass the FULL conversation history so the AI
      // has context from previous turns in this session
      final result = await sendAiQueryUseCase(
        query:               event.query,
        conversationHistory: event.conversationHistory,
      );

      // Step 4: Append the AI's answer to the conversation
      _conversation = _conversation.withMessage(
        AiMessageEntity(role: 'assistant', content: result.answer),
      );

      // Step 5: Emit the answered state with everything Flutter needs
      emit(AiAssistantAnswered(
        conversation:       _conversation,
        statCards:          result.statCards,
        suggestedFollowUps: result.suggestedFollowUps,
      ));

    } catch (e) {
      // On failure: show the error but keep the conversation so far visible
      // by emitting AiAssistantAnswered with the error as the last message
      _conversation = _conversation.withMessage(
        const AiMessageEntity(
          role: 'assistant',
          content: 'Sorry, I could not process your request. Please try again.',
        ),
      );
      emit(AiAssistantAnswered(
        conversation:       _conversation,
        statCards:          [],
        suggestedFollowUps: [],
      ));
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // _onSuggestionTapped — AiSuggestionTapped
  // ─────────────────────────────────────────────────────────────────────────
  // Suggestion chips always start a fresh conversation (no prior history).
  // Delegates to the query handler with an empty conversation history.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _onSuggestionTapped(
      AiSuggestionTapped event, Emitter<AiAssistantState> emit) async {
    // Reset conversation for a fresh start
    _conversation = const AiConversationEntity();

    // Dispatch as a regular query with no history
    add(AiQuerySubmitted(
      query:               event.question,
      conversationHistory: [],
    ));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // _onHistoryItemTapped — AiHistoryItemTapped
  // ─────────────────────────────────────────────────────────────────────────
  // Re-runs a past query as a fresh conversation (no prior context).
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _onHistoryItemTapped(
      AiHistoryItemTapped event, Emitter<AiAssistantState> emit) async {
    _conversation = const AiConversationEntity();

    add(AiQuerySubmitted(
      query:               event.queryText,
      conversationHistory: [],
    ));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // _onReset — AiConversationReset
  // ─────────────────────────────────────────────────────────────────────────
  // Clears the conversation and returns to the ready/start screen.
  // Uses cached suggestions to avoid an extra network call.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _onReset(
      AiConversationReset event, Emitter<AiAssistantState> emit) async {
    _conversation = const AiConversationEntity();

    // Reload fresh history but use cached suggestions for instant feedback
    try {
      final recentQueries = await getRecentQueriesUseCase();
      emit(AiAssistantReady(
        suggestions:   _cachedSuggestions,
        recentQueries: recentQueries,
      ));
    } catch (_) {
      // Even if history reload fails, show the start screen with suggestions
      emit(AiAssistantReady(
        suggestions:   _cachedSuggestions,
        recentQueries: [],
      ));
    }
  }
}