// =============================================================================
// FILE: ai_conversation_entity.dart
// PATH: lib/features/owner/ai_assistant/domain/entities/ai_conversation_entity.dart
// LAYER: Domain Layer → Entities
// =============================================================================
// Holds the full ordered list of messages exchanged so far in a session.
//
// The BLoC keeps one AiConversationEntity in memory per screen session.
// On every new query:
//   1. A new AiMessageEntity(role:"user", content: query) is appended
//   2. The API is called with all messages as conversationHistory
//   3. A new AiMessageEntity(role:"assistant", content: answer) is appended
//
// The conversation resets when the owner leaves the screen (BLoC is closed).
// =============================================================================

import 'ai_message_entity.dart';

class AiConversationEntity {
  final List<AiMessageEntity> messages;

  const AiConversationEntity({this.messages = const []});

  /// Returns a new conversation with [message] added to the end.
  /// Immutable pattern — matches how the BLoC emits new states.
  AiConversationEntity withMessage(AiMessageEntity message) {
    return AiConversationEntity(messages: [...messages, message]);
  }

  /// True when at least one message exists (used to decide which UI to show).
  bool get hasMessages => messages.isNotEmpty;
}