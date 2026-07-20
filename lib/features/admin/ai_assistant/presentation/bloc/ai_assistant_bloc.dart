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

  AiConversationEntity _conversation = const AiConversationEntity();
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

  Future<void> _onStarted(
      AiAssistantStarted event, Emitter<AiAssistantState> emit) async {
    emit(const AiAssistantLoading());
    try {
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

  Future<void> _onQuerySubmitted(
      AiQuerySubmitted event, Emitter<AiAssistantState> emit) async {
    _conversation = _conversation.withMessage(
      AiMessageEntity(role: 'user', content: event.query),
    );
    emit(AiAssistantQuerying(conversation: _conversation));

    try {
      final result = await sendAiQueryUseCase(
        query:               event.query,
        conversationHistory: event.conversationHistory,
      );

      // The HTTP call succeeded, but the backend may still report that no
      // real AI answer was produced (provider disabled, timeout, missing
      // context, invalid response). In that case `answer` is not a genuine
      // AI reply — show a translated, stable message instead.
      final replyText = result.dataAvailable
          ? result.answer
          : event.translateErrorCode(result.errorCode);

      _conversation = _conversation.withMessage(
        AiMessageEntity(role: 'assistant', content: replyText),
      );
      emit(AiAssistantAnswered(
        conversation:       _conversation,
        statCards:          result.statCards,
        suggestedFollowUps: result.suggestedFollowUps,
        errorCode:          result.dataAvailable ? null : result.errorCode,
      ));
    } catch (e) {
      // Use the localised error string passed in from the screen
      _conversation = _conversation.withMessage(
        AiMessageEntity(role: 'assistant', content: event.errorFallbackMessage),
      );
      emit(AiAssistantAnswered(
        conversation:       _conversation,
        statCards:          [],
        suggestedFollowUps: [],
      ));
    }
  }

  Future<void> _onSuggestionTapped(
      AiSuggestionTapped event, Emitter<AiAssistantState> emit) async {
    _conversation = const AiConversationEntity();
    add(AiQuerySubmitted(
      query:                event.question,
      conversationHistory:  [],
      errorFallbackMessage: event.errorFallbackMessage,
      translateErrorCode:   event.translateErrorCode,
    ));
  }

  Future<void> _onHistoryItemTapped(
      AiHistoryItemTapped event, Emitter<AiAssistantState> emit) async {
    _conversation = const AiConversationEntity();
    add(AiQuerySubmitted(
      query:                event.queryText,
      conversationHistory:  [],
      errorFallbackMessage: event.errorFallbackMessage,
      translateErrorCode:   event.translateErrorCode,
    ));
  }

  Future<void> _onReset(
      AiConversationReset event, Emitter<AiAssistantState> emit) async {
    _conversation = const AiConversationEntity();
    try {
      final recentQueries = await getRecentQueriesUseCase();
      emit(AiAssistantReady(
        suggestions:   _cachedSuggestions,
        recentQueries: recentQueries,
      ));
    } catch (_) {
      emit(AiAssistantReady(
        suggestions:   _cachedSuggestions,
        recentQueries: [],
      ));
    }
  }
}