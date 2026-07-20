import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/admin/pt_dashboard/data/models/pt_session_model.dart';

// Covers the two new PtSessionStatus values added this session
// (DECLINED, PAYMENT_PENDING on the backend enum) plus CHECKED_IN, which
// the new trainer check-in action transitions a session into. The status
// field is a passthrough string, so parsing itself was never broken, but
// PtSessionEntity.isDeclined/isCheckedIn getters (added this session) must
// recognize them correctly.
void main() {
  Map<String, dynamic> sessionJson(String status) => {
        'ptSessionId': 1,
        'userId': 20,
        'startTime': '2026-07-20T09:00:00',
        'endTime': '2026-07-20T10:00:00',
        'status': status,
      };

  group('PtSessionModel/Entity status parsing', () {
    test('DECLINED status round-trips and isDeclined is true', () {
      final model = PtSessionModel.fromJson(sessionJson('DECLINED'));
      final entity = model.toEntity();

      expect(model.status, 'DECLINED');
      expect(entity.isDeclined, isTrue);
      expect(entity.isCancelled, isFalse);
    });

    test('CHECKED_IN status round-trips and isCheckedIn is true', () {
      final model = PtSessionModel.fromJson(sessionJson('CHECKED_IN'));
      final entity = model.toEntity();

      expect(model.status, 'CHECKED_IN');
      expect(entity.isCheckedIn, isTrue);
      expect(entity.isScheduled, isFalse);
    });

    test('PAYMENT_PENDING status round-trips without crashing '
        '(no dedicated getter — passthrough string only)', () {
      final model = PtSessionModel.fromJson(sessionJson('PAYMENT_PENDING'));

      expect(model.status, 'PAYMENT_PENDING');
    });
  });
}
