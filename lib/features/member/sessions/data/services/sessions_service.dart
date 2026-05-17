import 'package:dio/dio.dart';

import '../models/book_session_model.dart';
import '../models/filter_options_model.dart';
import '../models/session_card_model.dart';
import '../models/session_detail_model.dart';

class SessionsService {
  final Dio _dio;

  SessionsService(this._dio);

  Future<List<SessionCardModel>> getSessions({
    required DateTime date,
    int? classTypeId,
    int? trainerId,
    String? branchId,
  }) async {
    final response = await _dio.get(
      '/api/member/services',
      queryParameters: {
        'date': date.toIso8601String().split('T').first,
        if (classTypeId != null) 'classTypeId': classTypeId,
        if (trainerId != null) 'trainerId': trainerId,
        if (branchId != null) 'branchId': branchId,
      },
    );

    return (response.data as List)
        .map((item) => SessionCardModel.fromJson(item))
        .toList();
  }

  Future<FilterOptionsModel> getFilterOptions() async {
    final response = await _dio.get('/api/member/services/filter-options');

    return FilterOptionsModel.fromJson(response.data);
  }

  Future<BookSessionModel> bookSession(int sessionId) async {
    final response = await _dio.post(
      '/api/member/services/$sessionId/book',
    );

    return BookSessionModel.fromJson(response.data);
  }

  Future<void> cancelBooking(int bookingId) async {
    await _dio.delete(
      '/api/member/services/bookings/$bookingId',
    );
  }
  Future<SessionDetailModel> getSessionDetail(int sessionId) async {
    try {
      final response = await _dio.get('/api/member/services/$sessionId');

      print('SESSION DETAIL STATUS: ${response.statusCode}');
      print('SESSION DETAIL DATA: ${response.data}');
      print('SESSION DETAIL DATA TYPE: ${response.data.runtimeType}');

      final data = Map<String, dynamic>.from(response.data as Map);

      return SessionDetailModel.fromJson(data);
    } catch (e, s) {
      print('FAILED TO LOAD SESSION DETAIL ERROR: $e');
      print('STACKTRACE: $s');
      rethrow;
    }
  }
}