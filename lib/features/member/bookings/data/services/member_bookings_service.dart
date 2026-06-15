import 'package:dio/dio.dart';

import '../models/member_booking_model.dart';

/*
 * Remote service for member bookings API.
 *
 * Same style as:
 * - SessionsService
 * - MemberPtService
 *
 * This class knows HTTP endpoints only.
 * It does not contain UI logic.
 */
class MemberBookingsService {
  final Dio _dio;

  MemberBookingsService(this._dio);

  /*
   * Loads unified bookings:
   * - CLASS bookings
   * - PT sessions
   *
   * tab must be:
   * - UPCOMING
   * - PREVIOUS
   */
  Future<List<MemberBookingModel>> getBookings({
    required String tab,
  }) async {
    try {
      final response = await _dio.get(
        '/api/member/bookings',
        queryParameters: {
          'tab': tab,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      return (response.data as List)
          .map(
            (item) => MemberBookingModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList();
    } on DioException catch (e) {
      print('BOOKINGS GET ERROR URI: ${e.requestOptions.uri}');
      print('BOOKINGS GET ERROR STATUS: ${e.response?.statusCode}');
      print('BOOKINGS GET ERROR DATA: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('BOOKINGS PARSE ERROR: $e');
      rethrow;
    }
  }

  /*
   * Member requests cancellation for CLASS booking.
   *
   * This does not cancel directly.
   * Backend changes status:
   * BOOKED -> CANCEL_REQUESTED
   */
  Future<void> requestClassCancel(int bookingId) async {
    await _dio.post(
      '/api/member/bookings/class/$bookingId/cancel-request',
    );
  }

  /*
   * Member requests cancellation for PT session.
   *
   * This does not cancel directly.
   * Backend changes status:
   * SCHEDULED -> CANCEL_REQUESTED
   *
   * If requestedNewDate is provided, the member is also requesting
   * a reschedule to that date. Backend stores it for the trainer to review.
   */
  Future<void> requestPtCancel(int ptSessionId, {DateTime? requestedNewDate}) async {
    await _dio.post(
      '/api/member/bookings/pt/$ptSessionId/cancel-request',
      data: requestedNewDate != null
          ? {'requestedNewDate': requestedNewDate.toIso8601String().substring(0, 19)}
          : null,
    );
  }
  /*
 * Submit review for a completed CLASS booking.
 *
 * Endpoint:
 * POST /api/member/bookings/class/{bookingId}/review
 */
  Future<void> submitClassReview({
    required int bookingId,
    required int rating,
    String? comment,
  }) async {
    await _dio.post(
      '/api/member/bookings/class/$bookingId/review',
      data: {
        'rating': rating,
        'comment': comment,
      },
      options: Options(
        responseType: ResponseType.json,
      ),
    );
  }

  Future<void> submitPtReview({
    required int ptSessionId,
    required int rating,
    String? comment,
  }) async {
    await _dio.post(
      '/api/member/bookings/pt/$ptSessionId/review',
      data: {
        'rating': rating,
        'comment': comment,
      },
      options: Options(
        responseType: ResponseType.json,
      ),
    );
  }
}