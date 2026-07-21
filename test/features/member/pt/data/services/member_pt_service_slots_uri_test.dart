import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/member/pt/data/services/member_pt_service.dart';

// Covers the slots endpoint contract change: the backend replaced the old
// date-only /api/trainers/{id}/slots with
// GET /api/member/pt/trainers/{trainerId}/slots?branchId=&serviceId=&date=
// (branchId/serviceId are now required so the backend can resolve the
// PT service's durationMinutes). Verified here as a pure URI-builder
// function since this codebase has no http.Client-mocking seam to
// intercept the real request.
void main() {
  group('MemberPtService.buildAvailableSlotsUri', () {
    test('targets /api/member/pt/trainers/{trainerId}/slots, not the old '
        '/api/trainers/{id}/slots endpoint', () {
      final uri = MemberPtService.buildAvailableSlotsUri(
        trainerId: 10,
        branchId: 2,
        serviceId: 7,
        date: DateTime(2026, 7, 20),
      );

      expect(uri.path, '/api/member/pt/trainers/10/slots');
      expect(uri.path, isNot(contains('/api/trainers/10/slots')));
    });

    test('query parameters contain branchId, serviceId, and date', () {
      final uri = MemberPtService.buildAvailableSlotsUri(
        trainerId: 10,
        branchId: 2,
        serviceId: 7,
        date: DateTime(2026, 7, 20),
      );

      expect(uri.queryParameters['branchId'], '2');
      expect(uri.queryParameters['serviceId'], '7');
      expect(uri.queryParameters['date'], '2026-07-20');
    });

    test('date is zero-padded for single-digit month/day', () {
      final uri = MemberPtService.buildAvailableSlotsUri(
        trainerId: 1,
        branchId: 1,
        serviceId: 1,
        date: DateTime(2026, 3, 5),
      );

      expect(uri.queryParameters['date'], '2026-03-05');
    });
  });
}
