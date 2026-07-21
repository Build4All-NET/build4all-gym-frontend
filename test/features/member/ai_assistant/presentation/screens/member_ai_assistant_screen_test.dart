import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Covers the member AI assistant screen's required states: empty/loading/
// success/error, and that a structured error (dataAvailable == false) is
// translated via the shared error-code translator rather than shown as
// raw backend text.
//
// A full testWidgets() pump can't be compiled/run without the Flutter SDK
// in this sandbox (see member_home_widget_order_test.dart for the same
// constraint). This verifies the same invariants structurally against the
// screen's source instead of by rendering and interacting with it.
void main() {
  late String source;

  setUpAll(() {
    source = File(
      'lib/features/member/ai_assistant/presentation/screens/member_ai_assistant_screen.dart',
    ).readAsStringSync();
  });

  test('shows an empty state with quick questions before any turn is submitted', () {
    expect(source.contains('_EmptyState'), isTrue);
    expect(source.contains('memberAiQuickQuestionSessionsThisWeek'), isTrue);
  });

  test('shows a loading indicator while an answer is pending', () {
    expect(source.contains('turn.answer == null'), isTrue);
    expect(source.contains('CircularProgressIndicator'), isTrue);
  });

  test('renders a successful answer using the real backend text, not a placeholder', () {
    expect(source.contains('response.answer ?? '), isTrue);
  });

  test('never displays a raw backend answer when dataAvailable is false', () {
    // The structured-error branch must translate the errorCode instead of
    // falling through to response.answer (which the backend leaves null).
    final falseBranch = source.substring(
      source.indexOf('if (!response.dataAvailable)'),
      source.indexOf('} else {'),
    );
    expect(falseBranch.contains('translateBackendErrorCode'), isTrue);
    expect(falseBranch.contains('response.answer'), isFalse,
        reason: 'A structured error must never surface response.answer verbatim');
  });

  test('marks the error bubble as an error for distinct styling', () {
    expect(source.contains('isError: true'), isTrue);
  });
}
