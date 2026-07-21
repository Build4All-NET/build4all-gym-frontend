// Matches the backend MemberAiQueryResponse shape:
//   {
//     "answer": "You have 3 PT sessions scheduled this week.",
//     "suggestions": ["Want to book another session?"],
//     "dataAvailable": true,
//     "errorCode": null
//   }
//
// The backend always answers HTTP 200 — even when the AI provider is
// disabled, times out, or the member's context couldn't be loaded. In
// those cases dataAvailable is false and errorCode explains why; answer is
// null and must NEVER be displayed as if it were a real AI reply.
class MemberAiQueryResponseModel {
  final String? answer;
  final List<String> suggestions;
  final bool dataAvailable;
  final String? errorCode;

  const MemberAiQueryResponseModel({
    required this.answer,
    required this.suggestions,
    required this.dataAvailable,
    this.errorCode,
  });

  factory MemberAiQueryResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuggestions = json['suggestions'] as List<dynamic>? ?? [];

    return MemberAiQueryResponseModel(
      answer: json['answer'] as String?,
      suggestions: rawSuggestions.map((s) => s.toString()).toList(),
      dataAvailable: json['dataAvailable'] as bool? ?? true,
      errorCode: json['errorCode'] as String?,
    );
  }
}
