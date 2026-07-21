import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/member/pt/data/models/pt_booking_request_model.dart';
import 'package:build4allgym/features/member/pt/data/models/pt_booking_response_model.dart';

// Covers spec section 3/22: the member direct-booking request/response
// contract must match the backend's PTBookingRequestDto / PTSessionResponseDto
// exactly (POST /api/pt-sessions — see member_pt_service.dart createBooking(),
// fixed to no longer POST to /api/pt-services).
void main() {
  group('PtBookingRequestModel', () {
    test('serializes required fields and omits notes when blank', () {
      const request = PtBookingRequestModel(
        trainerId: 15,
        startTime: '2026-07-20T15:00:00',
        endTime: '2026-07-20T16:00:00',
      );

      final json = request.toJson();

      expect(json['trainerId'], 15);
      expect(json['startTime'], '2026-07-20T15:00:00');
      expect(json['endTime'], '2026-07-20T16:00:00');
      expect(json.containsKey('notes'), isFalse);
    });

    test('includes notes when present and non-empty', () {
      const request = PtBookingRequestModel(
        trainerId: 15,
        startTime: '2026-07-20T15:00:00',
        endTime: '2026-07-20T16:00:00',
        notes: 'Focus on legs',
      );

      final json = request.toJson();

      expect(json['notes'], 'Focus on legs');
    });
  });

  group('PtBookingResponseModel.fromJson', () {
    test('parses the full PTSessionResponseDto shape', () {
      final model = PtBookingResponseModel.fromJson({
        'ptSessionId': 51,
        'trainerId': 15,
        'userId': 7,
        'branchId': 2,
        'startTime': '2026-07-20T15:00:00',
        'endTime': '2026-07-20T16:00:00',
        'status': 'SCHEDULED',
        'trainerName': 'Ahmad',
      });

      expect(model.ptSessionId, 51);
      expect(model.trainerId, 15);
      expect(model.branchId, 2);
      expect(model.status, 'SCHEDULED');
      expect(model.trainerName, 'Ahmad');
    });
  });
}
