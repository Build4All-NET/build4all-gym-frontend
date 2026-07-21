import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/member/pt/presentation/widgets/trainer_card_widget.dart';

// Covers the localized restriction-code -> message mapping shown on a
// trainer card when bookable=false. Tested via the pure key-mapping
// function (no BuildContext/AppLocalizations needed) rather than a full
// widget test, since this sandbox has no Flutter SDK to run one.
void main() {
  group('TrainerCardWidget.restrictionMessageKey', () {
    test('NO_ACTIVE_MEMBERSHIP maps to the noActiveMembership ARB key', () {
      expect(
        TrainerCardWidget.restrictionMessageKey('NO_ACTIVE_MEMBERSHIP'),
        TrainerCardWidget.restrictionKeyNoMembership,
      );
    });

    test('TRAINER_NOT_AVAILABLE_AT_MEMBERSHIP_BRANCH maps to the '
        'trainerNotAvailableAtYourBranch ARB key', () {
      expect(
        TrainerCardWidget.restrictionMessageKey(
            'TRAINER_NOT_AVAILABLE_AT_MEMBERSHIP_BRANCH'),
        TrainerCardWidget.restrictionKeyWrongBranch,
      );
    });

    test('unknown/null restriction codes fall back to the generic '
        'trainerNotBookable ARB key', () {
      expect(
        TrainerCardWidget.restrictionMessageKey('SOME_FUTURE_CODE'),
        TrainerCardWidget.restrictionKeyDefault,
      );
      expect(
        TrainerCardWidget.restrictionMessageKey(null),
        TrainerCardWidget.restrictionKeyDefault,
      );
    });
  });
}
