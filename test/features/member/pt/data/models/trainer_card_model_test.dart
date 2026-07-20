import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/member/pt/data/models/trainer_card_model.dart';

// Covers the multi-branch trainer contract: branches[], bookable,
// bookableBranchId, restrictionCode. Previously a trainer assigned to more
// than one branch only ever exposed a single arbitrary branchId/branchName.
void main() {
  group('TrainerCardModel.fromJson', () {
    test('parses multiple branches from branches[]', () {
      final model = TrainerCardModel.fromJson({
        'trainerId': 10,
        'fullName': 'Ahmad',
        'specialties': ['Strength'],
        'certifications': [],
        'pricePerSession': 50.0,
        'reviewCount': 3,
        'avgRating': 4.5,
        'isFavorited': false,
        'isOnline': true,
        'branches': [
          {'branchId': 1, 'branchName': 'Saida'},
          {'branchId': 2, 'branchName': 'Beirut'},
        ],
        'bookable': true,
        'bookableBranchId': 1,
      });

      expect(model.branches, hasLength(2));
      expect(model.branches[0].branchId, 1);
      expect(model.branches[0].branchName, 'Saida');
      expect(model.branches[1].branchId, 2);
      expect(model.branches[1].branchName, 'Beirut');
      expect(model.bookable, isTrue);
      expect(model.bookableBranchId, 1);
      expect(model.restrictionCode, isNull);
    });

    test('defaults bookable to true and branches to empty when omitted '
        '(older API responses without the field must not be hidden)', () {
      final model = TrainerCardModel.fromJson({
        'trainerId': 11,
        'fullName': 'Sara',
        'specialties': [],
        'certifications': [],
        'pricePerSession': 40.0,
        'reviewCount': 0,
        'avgRating': 0.0,
        'isFavorited': false,
        'isOnline': false,
      });

      expect(model.branches, isEmpty);
      expect(model.bookable, isTrue);
      expect(model.bookableBranchId, isNull);
      expect(model.restrictionCode, isNull);
    });

    test('parses bookable=false with a restrictionCode', () {
      final model = TrainerCardModel.fromJson({
        'trainerId': 12,
        'fullName': 'Karim',
        'specialties': [],
        'certifications': [],
        'pricePerSession': 60.0,
        'reviewCount': 0,
        'avgRating': 0.0,
        'isFavorited': false,
        'isOnline': false,
        'bookable': false,
        'restrictionCode': 'NO_ACTIVE_MEMBERSHIP',
      });

      expect(model.bookable, isFalse);
      expect(model.restrictionCode, 'NO_ACTIVE_MEMBERSHIP');
      expect(model.bookableBranchId, isNull);
    });

    test('toEntity carries branches/bookable/restrictionCode through', () {
      final model = TrainerCardModel.fromJson({
        'trainerId': 13,
        'fullName': 'Lina',
        'specialties': [],
        'certifications': [],
        'pricePerSession': 30.0,
        'reviewCount': 0,
        'avgRating': 0.0,
        'isFavorited': false,
        'isOnline': false,
        'branches': [
          {'branchId': 5, 'branchName': 'Tripoli'},
        ],
        'bookable': false,
        'restrictionCode': 'TRAINER_NOT_AVAILABLE_AT_MEMBERSHIP_BRANCH',
      });

      final entity = model.toEntity();

      expect(entity.branches, hasLength(1));
      expect(entity.branches.first.branchName, 'Tripoli');
      expect(entity.bookable, isFalse);
      expect(entity.restrictionCode, 'TRAINER_NOT_AVAILABLE_AT_MEMBERSHIP_BRANCH');
    });
  });
}
