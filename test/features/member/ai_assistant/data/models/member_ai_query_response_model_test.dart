import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/member/ai_assistant/data/models/member_ai_query_response_model.dart';

// Covers the member-facing AI assistant: the backend always answers HTTP
// 200, even when the provider is disabled/unavailable, so the model must
// surface dataAvailable/errorCode rather than let a null/error message be
// mistaken for a real AI answer.
void main() {
  group('MemberAiQueryResponseModel.fromJson', () {
    test('parses a successful structured answer', () {
      final model = MemberAiQueryResponseModel.fromJson({
        'answer': 'You have 3 PT sessions scheduled this week.',
        'suggestions': ['Want to book another session?'],
        'dataAvailable': true,
        'errorCode': null,
      });

      expect(model.answer, 'You have 3 PT sessions scheduled this week.');
      expect(model.suggestions, ['Want to book another session?']);
      expect(model.dataAvailable, isTrue);
      expect(model.errorCode, isNull);
    });

    test('parses a structured error response with a null answer', () {
      final model = MemberAiQueryResponseModel.fromJson({
        'answer': null,
        'suggestions': [],
        'dataAvailable': false,
        'errorCode': 'AI_CONTEXT_UNAVAILABLE',
      });

      expect(model.answer, isNull);
      expect(model.dataAvailable, isFalse);
      expect(model.errorCode, 'AI_CONTEXT_UNAVAILABLE');
    });

    test('defaults dataAvailable to true and suggestions to empty when omitted', () {
      final model = MemberAiQueryResponseModel.fromJson({
        'answer': 'Some answer',
      });

      expect(model.dataAvailable, isTrue);
      expect(model.suggestions, isEmpty);
      expect(model.errorCode, isNull);
    });
  });
}
