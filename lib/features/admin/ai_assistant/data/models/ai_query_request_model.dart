// =============================================================================
// FILE: ai_query_request_model.dart
// PATH: lib/features/owner/ai_assistant/data/models/ai_query_request_model.dart
// LAYER: Data Layer → Models
// =============================================================================
// Serialises the owner's query + conversation history into the JSON body
// expected by POST /api/owner/ai-assistant/query.
//
// Backend AiQueryRequest.java shape:
//   {
//     "query": "What is my revenue this month?",
//     "conversationHistory": [
//       { "role": "user",      "content": "..." },
//       { "role": "assistant", "content": "..." }
//     ]
//   }
//
// conversationHistory is List<Map<String,String>> — each map has exactly
// "role" and "content" keys matching the Claude API's message format.
// =============================================================================

import '../../domain/entities/ai_message_entity.dart';

class AiQueryRequestModel {
  final String                    query;
  final List<AiMessageEntity>     conversationHistory;

  const AiQueryRequestModel({
    required this.query,
    required this.conversationHistory,
  });

  // ── Serialise to JSON for the HTTP POST body ───────────────────────────────
  // conversationHistory is flattened to a List<Map<String,String>> because
  // that is what the backend's AiQueryRequest.conversationHistory expects.
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'conversationHistory': conversationHistory
          .map((msg) => {'role': msg.role, 'content': msg.content})
          .toList(),
    };
  }
}