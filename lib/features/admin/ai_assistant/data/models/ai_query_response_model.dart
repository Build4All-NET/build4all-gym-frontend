// =============================================================================
// FILE: ai_query_response_model.dart
// PATH: lib/features/owner/ai_assistant/data/models/ai_query_response_model.dart
// LAYER: Data Layer → Models
// =============================================================================
// Deserialises the JSON body returned by POST /api/owner/ai-assistant/query.
//
// Backend AiQueryResponse.java shape:
//   {
//     "answer": "Your revenue this month is $4,200, up 15%.",
//     "statCards": [
//       { "icon": "revenue_growth", "label": "Monthly Revenue",
//         "value": "$4,200", "trend": "+15%" }
//     ],
//     "suggestedFollowUps": [
//       "Which plan generates the most revenue?",
//       "How many members renewed this month?"
//     ]
//   }
//
// toEntity() converts to AiQueryResult (defined in the repository interface)
// which the repository impl returns to the BLoC via the use case.
// =============================================================================

import '../../../../admin/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import 'ai_stat_card_model.dart';

class AiQueryResponseModel {
  final String                answer;
  final List<AiStatCardModel> statCards;
  final List<String>          suggestedFollowUps;

  // False when the backend could not produce a real AI answer (provider
  // disabled, missing context, timeout, or an invalid provider response).
  // The UI must not treat `answer` as a genuine AI answer in that case —
  // it should show a localized message derived from `errorCode` instead.
  final bool                  dataAvailable;
  final String?               errorCode;

  const AiQueryResponseModel({
    required this.answer,
    required this.statCards,
    required this.suggestedFollowUps,
    required this.dataAvailable,
    this.errorCode,
  });

  // ── Deserialise from the backend JSON ─────────────────────────────────────
  factory AiQueryResponseModel.fromJson(Map<String, dynamic> json) {
    // statCards: parse each element in the array; default to empty list
    final rawCards = json['statCards'] as List<dynamic>? ?? [];
    final statCards = rawCards
        .map((c) => AiStatCardModel.fromJson(c as Map<String, dynamic>))
        .toList();

    // suggestedFollowUps: list of plain strings; default to empty list
    final rawFollowUps = json['suggestedFollowUps'] as List<dynamic>? ?? [];
    final followUps = rawFollowUps.map((f) => f as String).toList();

    return AiQueryResponseModel(
      answer:             json['answer'] as String? ?? '',
      statCards:          statCards,
      suggestedFollowUps: followUps,
      dataAvailable:      json['dataAvailable'] as bool? ?? true,
      errorCode:          json['errorCode'] as String?,
    );
  }

  // ── Convert to the domain result object ───────────────────────────────────
  // AiQueryResult is defined in the repository abstract file (domain layer).
  // The repository impl calls this after deserialisation.
  AiQueryResult toEntity() {
    return AiQueryResult(
      answer:             answer,
      statCards:          statCards.map((c) => c.toEntity()).toList(),
      suggestedFollowUps: suggestedFollowUps,
      dataAvailable:      dataAvailable,
      errorCode:          errorCode,
    );
  }
}