// =============================================================================
// FILE: ai_message_entity.dart
// PATH: lib/features/owner/ai_assistant/domain/entities/ai_message_entity.dart
// LAYER: Domain Layer → Entities
// =============================================================================
// Represents a single turn in the AI conversation.
//
// role    → "user" (owner typed this) or "assistant" (AI replied)
// content → the raw text of that message
//
// Used by:
//   - AiConversationEntity   (holds a list of these)
//   - AiAssistantBloc        (builds conversationHistory for the next request)
//   - AiQueryRequestModel    (serialised to JSON for the API)
// =============================================================================

class AiMessageEntity {
  final String role;     // "user" | "assistant"
  final String content;  // the message text

  const AiMessageEntity({
    required this.role,
    required this.content,
  });
}