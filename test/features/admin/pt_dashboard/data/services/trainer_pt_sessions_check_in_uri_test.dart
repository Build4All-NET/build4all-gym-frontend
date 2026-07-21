import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/admin/pt_dashboard/data/services/trainer_pt_sessions_service.dart';

// Covers the new trainer check-in action added this session
// (SCHEDULED -> CHECKED_IN), calling
// PATCH /api/trainer/pt-sessions/{id}/check-in
// (matches TrainerPtSessionController.checkIn's @PatchMapping("/{id}/check-in")
// on the backend). The HTTP method itself is verified by direct code
// reading (TrainerPtSessionsService.checkIn calls `_client.patch(...)`,
// see trainer_pt_sessions_service.dart) since this codebase has no
// http.Client-mocking seam to intercept the real request.
void main() {
  group('TrainerPtSessionsService.buildCheckInUri', () {
    test('targets PATCH /api/trainer/pt-sessions/{id}/check-in', () {
      final uri = TrainerPtSessionsService.buildCheckInUri(500);

      expect(uri.path, '/api/trainer/pt-sessions/500/check-in');
    });

    test('embeds the exact session id requested, not a hardcoded one', () {
      final uri = TrainerPtSessionsService.buildCheckInUri(999);

      expect(uri.path, '/api/trainer/pt-sessions/999/check-in');
      expect(uri.path, isNot(contains('/500/')));
    });
  });
}
