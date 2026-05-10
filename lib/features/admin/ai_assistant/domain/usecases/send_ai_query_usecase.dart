// =============================================================================
// FILE: send_ai_query_usecase.dart
// PATH: lib/features/owner/ai_assistant/domain/usecases/send_ai_query_usecase.dart
// LAYER: Domain Layer → Use Cases
// =============================================================================
// Single-responsibility class for sending an AI query.
//
// The BLoC calls this when it handles the AiQuerySubmitted event.
// It sits between the BLoC and the repository — the BLoC never talks to
// the repository directly.
//
// FLOW:
//   AiAssistantBloc (on AiQuerySubmitted)
//     → SendAiQueryUseCase.call(query, conversationHistory)
//     → AiAssistantRepository.sendQuery(...)        ← abstract
//     ← AiAssistantRepositoryImpl does HTTP + mapping
//     ← AiQueryResult returned to BLoC
// =============================================================================

import '../entities/ai_message_entity.dart';
import '../repositories/ai_assistant_repository.dart';

class SendAiQueryUseCase {
  final AiAssistantRepository repository;

  SendAiQueryUseCase(this.repository);

  /// Named `call` so the BLoC can call it as `sendAiQueryUseCase(...)`.
  Future<AiQueryResult> call({
    required String                query,
    required List<AiMessageEntity> conversationHistory,
  }) {
    return repository.sendQuery(
      query: query,
      conversationHistory: conversationHistory,
    );
  }
}