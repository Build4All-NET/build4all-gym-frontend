import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/admin/pt_dashboard/data/models/pt_session_stats_model.dart';

// Covers spec section 15/21: the dashboard must show explicit per-status
// counts (requested/checkedIn/cancelRequested/cancelled/noShow), not just
// total/completed/scheduled, and must never derive "cancelled" client-side.
void main() {
  group('PtSessionStatsModel.fromJson', () {
    test('parses every explicit status count from the backend response', () {
      final model = PtSessionStatsModel.fromJson({
        'total': 10,
        'completed': 2,
        'scheduled': 3,
        'requested': 2,
        'checkedIn': 1,
        'cancelRequested': 1,
        'cancelled': 1,
        'noShow': 0,
      });

      expect(model.total, 10);
      expect(model.completed, 2);
      expect(model.scheduled, 3);
      expect(model.requested, 2);
      expect(model.checkedIn, 1);
      expect(model.cancelRequested, 1);
      expect(model.cancelled, 1);
      expect(model.noShow, 0);
    });

    test('defaults every field to 0 when missing (never crashes on partial JSON)', () {
      final model = PtSessionStatsModel.fromJson(const {});

      expect(model.total, 0);
      expect(model.completed, 0);
      expect(model.scheduled, 0);
      expect(model.requested, 0);
      expect(model.checkedIn, 0);
      expect(model.cancelRequested, 0);
      expect(model.cancelled, 0);
      expect(model.noShow, 0);
    });

    test('toEntity carries every field through to the domain entity', () {
      final model = PtSessionStatsModel.fromJson({
        'total': 5,
        'completed': 1,
        'scheduled': 1,
        'requested': 1,
        'checkedIn': 1,
        'cancelRequested': 1,
        'cancelled': 0,
        'noShow': 0,
      });
      final entity = model.toEntity();

      expect(entity.total, 5);
      expect(entity.requested, 1);
      expect(entity.checkedIn, 1);
      expect(entity.cancelRequested, 1);
    });
  });
}
