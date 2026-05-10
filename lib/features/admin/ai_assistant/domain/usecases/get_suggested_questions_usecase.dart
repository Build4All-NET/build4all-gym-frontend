// =============================================================================
// FILE: get_suggested_questions_usecase.dart
// PATH: lib/features/owner/ai_assistant/domain/usecases/get_suggested_questions_usecase.dart
// LAYER: Domain Layer → Use Cases
// =============================================================================
// Fetches the 5 hardcoded suggested questions from the backend.
//
// Called by the BLoC on AiAssistantStarted — loads the "empty state" chips
// shown before the owner types anything.
// =============================================================================

import '../entities/suggested_question_entity.dart';
import '../repositories/ai_assistant_repository.dart';

class GetSuggestedQuestionsUseCase {
  final AiAssistantRepository repository;

  GetSuggestedQuestionsUseCase(this.repository);

  Future<List<SuggestedQuestionEntity>> call() {
    return repository.getSuggestedQuestions();
  }
}