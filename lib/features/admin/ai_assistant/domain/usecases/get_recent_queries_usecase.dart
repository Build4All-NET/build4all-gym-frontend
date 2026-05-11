// =============================================================================
// FILE: get_recent_queries_usecase.dart
// PATH: lib/features/owner/ai_assistant/domain/usecases/get_recent_queries_usecase.dart
// LAYER: Domain Layer → Use Cases
// =============================================================================
// Fetches the last 10 queries this owner made from the backend.
//
// Called by the BLoC on AiAssistantStarted — populates the "Recent Queries"
// section shown below the suggested questions on the start screen.
// =============================================================================

import '../entities/ai_query_history_entity.dart';
import '../repositories/ai_assistant_repository.dart';

class GetRecentQueriesUseCase {
  final AiAssistantRepository repository;

  GetRecentQueriesUseCase(this.repository);

  Future<List<AiQueryHistoryEntity>> call() {
    return repository.getRecentQueries();
  }
}