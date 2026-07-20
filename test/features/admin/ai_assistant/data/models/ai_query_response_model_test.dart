import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/admin/ai_assistant/data/models/ai_query_response_model.dart';

// Covers the AI stabilization work: the backend always returns HTTP 200,
// but a `dataAvailable: false` body means the provider is disabled, timed
// out, or produced an invalid response — not a real AI answer. The Flutter
// model must surface that distinction instead of treating `answer` as
// genuine AI output.
void main() {
  group('AiQueryResponseModel.fromJson', () {
    test('parses a successful structured answer with dataAvailable true', () {
      final model = AiQueryResponseModel.fromJson({
        'answer': 'Your revenue this month is \$4,200, up 15%.',
        'statCards': [
          {'icon': 'revenue_growth', 'label': 'Monthly Revenue', 'value': '\$4,200', 'trend': '+15%'},
        ],
        'suggestedFollowUps': ['Which plan generates the most revenue?'],
        'dataAvailable': true,
        'errorCode': null,
      });

      expect(model.answer, 'Your revenue this month is \$4,200, up 15%.');
      expect(model.statCards, hasLength(1));
      expect(model.suggestedFollowUps, hasLength(1));
      expect(model.dataAvailable, isTrue);
      expect(model.errorCode, isNull);
    });

    test('defaults dataAvailable to true when the backend omits it', () {
      // Older/legacy response shape without the field — must not be
      // misread as an error state.
      final model = AiQueryResponseModel.fromJson({
        'answer': 'Some answer',
        'statCards': [],
        'suggestedFollowUps': [],
      });

      expect(model.dataAvailable, isTrue);
      expect(model.errorCode, isNull);
    });

    test('parses a disabled-provider structured error response', () {
      final model = AiQueryResponseModel.fromJson({
        'answer': 'The AI assistant is currently unavailable. Please try again later.',
        'statCards': [],
        'suggestedFollowUps': [],
        'dataAvailable': false,
        'errorCode': 'AI_PROVIDER_DISABLED',
      });

      expect(model.dataAvailable, isFalse);
      expect(model.errorCode, 'AI_PROVIDER_DISABLED');
    });

    test('toEntity carries dataAvailable and errorCode through to the domain result', () {
      final model = AiQueryResponseModel.fromJson({
        'answer': 'unused when dataAvailable is false',
        'statCards': [],
        'suggestedFollowUps': [],
        'dataAvailable': false,
        'errorCode': 'AI_PROVIDER_TIMEOUT',
      });

      final entity = model.toEntity();

      expect(entity.dataAvailable, isFalse);
      expect(entity.errorCode, 'AI_PROVIDER_TIMEOUT');
    });
  });
}
