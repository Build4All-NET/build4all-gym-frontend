// =============================================================================
// FILE: ai_assistant_repository_impl.dart
// PATH: lib/features/owner/ai_assistant/data/repositories/ai_assistant_repository_impl.dart
// LAYER: Data Layer → Repositories (Concrete Implementation)
// =============================================================================
// Implements AiAssistantRepository (the abstract contract from domain layer).
//
// Responsibilities:
//   1. Call AiAssistantRemoteService (data layer)
//   2. Catch DioException and convert to plain Exception with a clean message
//   3. Convert data models to domain entities
//
// Pattern matches AdminMembersRepositoryImpl exactly — each method has the
// same try/catch structure with the same four exception types.
//
// POSITION IN FLOW:
//   AiAssistantBloc → Use Case → [this file] → AiAssistantRemoteService
//   HTTP response → Model.fromJson() → Model.toEntity() → Domain entity
//   → Use Case → BLoC emits state
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../../domain/entities/ai_message_entity.dart';
import '../../domain/entities/ai_query_history_entity.dart';
import '../../domain/entities/suggested_question_entity.dart';
import '../../domain/repositories/ai_assistant_repository.dart';
import '../models/ai_query_request_model.dart';
import '../services/ai_assistant_remote_service.dart';

class AiAssistantRepositoryImpl implements AiAssistantRepository {
  final AiAssistantRemoteService service;

  AiAssistantRepositoryImpl({required this.service});

  // ─────────────────────────────────────────────────────────────────────────
  // sendQuery — POST /api/owner/ai-assistant/query
  // ─────────────────────────────────────────────────────────────────────────
  // Builds the request model from domain entities, calls the service,
  // and maps the response model back to an AiQueryResult domain object.
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<AiQueryResult> sendQuery({
    required String                query,
    required List<AiMessageEntity> conversationHistory,
  }) async {
    try {
      // Build the data-layer request model from domain parameters
      final requestModel = AiQueryRequestModel(
        query:               query,
        conversationHistory: conversationHistory,
      );

      // Call the remote service → get the raw model back
      final responseModel = await service.sendQuery(requestModel);

      // Map model → domain result (AiQueryResult) and return to the use case
      return responseModel.toEntity();

    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to use the AI assistant.');
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // getSuggestedQuestions — GET /api/owner/ai-assistant/suggestions
  // ─────────────────────────────────────────────────────────────────────────
  // Returns 5 hardcoded suggested questions wrapped as domain entities.
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<List<SuggestedQuestionEntity>> getSuggestedQuestions() async {
    try {
      // Service returns List<String> (just the question text)
      final questions = await service.getSuggestions();

      // Wrap each string in the domain entity
      return questions
          .map((q) => SuggestedQuestionEntity(question: q))
          .toList();

    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to view suggestions.');
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // getRecentQueries — GET /api/owner/ai-assistant/history
  // ─────────────────────────────────────────────────────────────────────────
  // Returns last 10 queries as domain entities (newest first).
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<List<AiQueryHistoryEntity>> getRecentQueries() async {
    try {
      final models = await service.getHistory();

      // Map each model → domain entity using the model's toEntity() method
      return models.map((m) => m.toEntity()).toList();

    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to view query history.');
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }
}