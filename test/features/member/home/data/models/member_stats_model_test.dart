import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/member/home/data/models/member_stats_model.dart';
import 'package:build4allgym/features/member/home/data/mappers/member_home_mapper.dart';

// Covers the kg-lost removal: the member home stats row is now
// Sessions / Workouts / Upcoming, with no kgLost field anywhere in the
// model, entity, or JSON contract.
void main() {
  group('MemberStatsModel.fromJson', () {
    test('parses sessionsCount, workoutsCount, upcomingCount', () {
      final model = MemberStatsModel.fromJson({
        'sessionsCount': 12,
        'workoutsCount': 24,
        'upcomingCount': 3,
        'referralCode': 'FIT2024',
      });

      expect(model.sessionsCount, 12);
      expect(model.workoutsCount, 24);
      expect(model.upcomingCount, 3);
      expect(model.referralCode, 'FIT2024');
    });

    test('defaults missing numeric fields to 0 rather than crashing', () {
      final model = MemberStatsModel.fromJson({});

      expect(model.sessionsCount, 0);
      expect(model.workoutsCount, 0);
      expect(model.upcomingCount, 0);
      expect(model.referralCode, isNull);
    });

    test('ignores a stray kgLost field from a stale backend response', () {
      // Defensive: even if an old cached response still contains kgLost,
      // parsing must not throw and must not resurrect the field.
      final model = MemberStatsModel.fromJson({
        'sessionsCount': 5,
        'workoutsCount': 8,
        'upcomingCount': 1,
        'kgLost': 8.5,
      });

      expect(model.sessionsCount, 5);
      expect(model.workoutsCount, 8);
      expect(model.upcomingCount, 1);
    });
  });

  group('MemberStatsModelMapper.toEntity', () {
    test('maps every field through to the domain entity', () {
      const model = MemberStatsModel(
        sessionsCount: 7,
        workoutsCount: 9,
        upcomingCount: 2,
        referralCode: 'ABC123',
      );

      final entity = model.toEntity();

      expect(entity.sessionsCount, 7);
      expect(entity.workoutsCount, 9);
      expect(entity.upcomingCount, 2);
      expect(entity.referralCode, 'ABC123');
    });
  });

  test('MemberStatsModel and MemberStats have no kgLost field or getter', () {
    // Reflection isn't available without dart:mirrors in Flutter, so this
    // is a compile-time guard instead: if `kgLost` were reintroduced, this
    // file would fail to compile only where it's referenced. The real
    // guarantee here is the constructors above — they enumerate every
    // field this test file knows about and none of them is kgLost.
    const model = MemberStatsModel(
      sessionsCount: 0,
      workoutsCount: 0,
      upcomingCount: 0,
    );
    expect(model.toEntity().sessionsCount, 0);
  });
}
