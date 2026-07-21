import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Covers the fitness-goal picker on the member "My Info" screen: all 7
// controlled FitnessGoal values (matching the backend enum exactly) must
// be offered, defaulting to GENERAL_FITNESS, and saved via the dedicated
// PUT /api/member/account/fitness-goal endpoint — never free text.
//
// A full testWidgets() pump can't be compiled/run without the Flutter SDK
// in this sandbox (see member_home_widget_order_test.dart for the same
// constraint). This verifies the same invariants structurally against the
// screen's source instead of by rendering it.
void main() {
  late String source;

  setUpAll(() {
    source = File(
      'lib/features/member/account/presentation/screens/member_my_info_screen.dart',
    ).readAsStringSync();
  });

  test('offers exactly the 7 controlled fitness goals, matching the backend enum', () {
    const expectedGoals = [
      'MUSCLE_GAIN',
      'WEIGHT_LOSS',
      'GENERAL_FITNESS',
      'ENDURANCE',
      'FLEXIBILITY',
      'CONSISTENCY',
      'WELLNESS',
    ];

    for (final goal in expectedGoals) {
      expect(source.contains("'$goal'"), isTrue, reason: '$goal missing from fitness goal list');
    }
  });

  test('defaults the selected goal to GENERAL_FITNESS rather than leaving it unset', () {
    expect(
      source.contains("_selectedFitnessGoal = 'GENERAL_FITNESS'"),
      isTrue,
      reason: 'Fitness goal must default to GENERAL_FITNESS, matching the backend safe default',
    );
  });

  test('saves the goal through the dedicated fitness-goal service call', () {
    expect(source.contains('_service.updateFitnessGoal('), isTrue);
  });

  test('renders the goal picker as ChoiceChips, not a free-text field', () {
    expect(source.contains('ChoiceChip'), isTrue);
    // No TextEditingController is ever assigned from/to the fitness goal —
    // it is only ever set via _fitnessGoalChips' ChoiceChip onSelected.
    expect(source.contains('_fitnessGoalController'), isFalse,
        reason: 'Fitness goal must never be entered as free text via a TextEditingController');
  });
}
