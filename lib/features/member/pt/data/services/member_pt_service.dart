import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/auth_token_store.dart';

import '../models/trainer_list_response_model.dart';
import '../models/trainer_filter_options_model.dart';
import '../models/toggle_favorite_response_model.dart';
import '../models/trainer_detail_model.dart';
import '../models/time_slot_model.dart';

import '../models/pt_booking_request_model.dart';
import '../models/pt_booking_response_model.dart';

import '../models/pt_package_booking_request_model.dart';
import '../models/pt_package_booking_response_model.dart';

class MemberPtService {
  final _client = AuthedHttpClient();
  final AuthTokenStore _tokenStore;

  MemberPtService() : _tokenStore = const AuthTokenStore();

  // ─────────────────────────────────────────────────────────────
  // Shared auth headers
  // ─────────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  // ─────────────────────────────────────────────────────────────
  // Shared UTF-8 body decoder
  //
  // Fixes broken Arabic like:
  // Ø¨Ø§ÙØ© Ø£Ø³Ø¨ÙØ¹
  //
  // Never use response.body directly for Arabic text.
  // Always decode response.bodyBytes with utf8.
  // ─────────────────────────────────────────────────────────────

  String _decodeBody(http.Response response) {
    return utf8.decode(response.bodyBytes);
  }

  ServerException _serverException(http.Response response) {
    return ServerException(message: _decodeBody(response));
  }

  // ─────────────────────────────────────────────────────────────
  // GET /api/member/trainers
  //
  // Used by trainers list screen.
  // Backend resolves branchId from active membership.
  // ─────────────────────────────────────────────────────────────

  Future<TrainerListResponseModel> getTrainers({
    String? specialtyFilter,
    bool favoritesOnly = false,
  }) async {
    final headers = await _authHeaders();

    final queryParams = <String, String>{
      'favoritesOnly': favoritesOnly.toString(),
      if (specialtyFilter != null && specialtyFilter.trim().isNotEmpty)
        'specialtyFilter': specialtyFilter,
    };

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/member/trainers')
        .replace(queryParameters: queryParams);

    try {
      debugPrint('TRAINERS URI: $uri');

      final response = await _client.get(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('TRAINERS STATUS: ${response.statusCode}');
      debugPrint('TRAINERS BODY: $decodedBody');

      if (response.statusCode == 200) {
        return TrainerListResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('GET TRAINERS ERROR: $e');
      debugPrint('GET TRAINERS STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GET /api/member/trainers/filter-options
  //
  // Used by filter chips.
  // ─────────────────────────────────────────────────────────────

  Future<TrainerFilterOptionsModel> getFilterOptions() async {
    final headers = await _authHeaders();

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/trainers/filter-options',
    );

    try {
      final response = await _client.get(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('FILTER OPTIONS STATUS: ${response.statusCode}');
      debugPrint('FILTER OPTIONS BODY: $decodedBody');

      if (response.statusCode == 200) {
        return TrainerFilterOptionsModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('FILTER OPTIONS ERROR: $e');
      debugPrint('FILTER OPTIONS STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST /api/member/trainers/{trainerId}/favorite
  //
  // Toggles favorite state.
  // ─────────────────────────────────────────────────────────────

  Future<ToggleFavoriteResponseModel> toggleFavoriteTrainer(
      int trainerId,
      ) async {
    final headers = await _authHeaders();

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/trainers/$trainerId/favorite',
    );

    try {
      final response = await _client.post(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('TOGGLE FAVORITE STATUS: ${response.statusCode}');
      debugPrint('TOGGLE FAVORITE BODY: $decodedBody');

      if (response.statusCode == 200) {
        return ToggleFavoriteResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('TOGGLE FAVORITE ERROR: $e');
      debugPrint('TOGGLE FAVORITE STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GET /api/member/trainers/{trainerId}
  //
  // Used by trainer detail / package booking screen.
  // Backend returns packages inside trainer detail.
  // ─────────────────────────────────────────────────────────────

  Future<TrainerDetailModel> getTrainerDetail(int trainerId) async {
    final headers = await _authHeaders();

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/trainers/$trainerId',
    );

    try {
      debugPrint('DETAIL URI: $uri');

      final response = await _client.get(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('DETAIL STATUS: ${response.statusCode}');
      debugPrint('DETAIL BODY: $decodedBody');

      if (response.statusCode == 200) {
        return TrainerDetailModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('GET TRAINER DETAIL ERROR: $e');
      debugPrint('GET TRAINER DETAIL STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GET /api/trainers/{trainerId}/slots?date=YYYY-MM-DD
  //
  // Old single-session flow.
  // Keep it for now.
  // Do not use it for package weekly schedule.
  // ─────────────────────────────────────────────────────────────

  Future<List<TimeSlotModel>> getAvailableSlots({
    required int trainerId,
    required DateTime date,
  }) async {
    final headers = await _authHeaders();

    final formattedDate = _formatDate(date);

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainers/$trainerId/slots',
    ).replace(
      queryParameters: {
        'date': formattedDate,
      },
    );

    try {
      debugPrint('SLOTS URI: $uri');

      final response = await _client.get(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('SLOTS STATUS: ${response.statusCode}');
      debugPrint('SLOTS BODY: $decodedBody');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(decodedBody);

        if (decoded is! List) {
          throw ServerException(message: 'Invalid slots response.');
        }

        return decoded
            .map(
              (item) => TimeSlotModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
            .toList();
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('GET SLOTS ERROR: $e');
      debugPrint('GET SLOTS STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
  //
  // New package booking flow.
  //
  // Used when the member selects a stable weekday:
  // MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY.
  //
  // Backend returns recurring weekly slots from trainer availability.
  //
  // Important:
  // - No date is sent.
  // - Flutter should display only HH:mm from startTime.
  // - Time values are backend/internal values, not translated text.
  // ─────────────────────────────────────────────────────────────

  Future<List<TimeSlotModel>> getWeeklyAvailableSlots({
    required int trainerId,
    required String day,
    int? packageId,
  }) async {
    final headers = await _authHeaders();

    final queryParams = <String, String>{
      'day': day.trim().toUpperCase(),
      if (packageId != null) 'packageId': packageId.toString(),
    };

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/trainers/$trainerId/weekly-slots',
    ).replace(queryParameters: queryParams);

    try {
      debugPrint('WEEKLY SLOTS URI: $uri');

      final response = await _client.get(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('WEEKLY SLOTS STATUS: ${response.statusCode}');
      debugPrint('WEEKLY SLOTS BODY: $decodedBody');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(decodedBody);

        if (decoded is! List) {
          throw ServerException(message: 'Invalid weekly slots response.');
        }

        return decoded
            .map(
              (item) => TimeSlotModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
            .toList();
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('GET WEEKLY SLOTS ERROR: $e');
      debugPrint('GET WEEKLY SLOTS STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST /api/pt-sessions
  //
  // Direct single-session booking flow (confirmed slot -> SCHEDULED).
  // BUG FIX: this used to POST to /api/pt-services, the PT service
  // *catalog* endpoint (create/list a trainer's service offerings) —
  // not a booking endpoint at all. PtBookingRequestModel/PtBookingResponseModel
  // already match PTBookingController's /api/pt-sessions contract
  // (PTBookingRequestDto / PTSessionResponseDto) field-for-field, confirming
  // that was the intended endpoint. Do not use this for package booking —
  // see createPackageBooking() for /api/member/pt-package-bookings.
  // ─────────────────────────────────────────────────────────────

  Future<PtBookingResponseModel> createBooking(
      PtBookingRequestModel request,
      ) async {
    final headers = await _authHeaders();

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/pt-sessions');

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      final decodedBody = _decodeBody(response);

      debugPrint('PT BOOKING STATUS: ${response.statusCode}');
      debugPrint('PT BOOKING BODY: $decodedBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PtBookingResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('PT BOOKING ERROR: $e');
      debugPrint('PT BOOKING STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST /api/pt-sessions/request
  //
  // New request flow.
  //
  // Used when:
  // - the slot is full
  // - the slot is unavailable
  // - member still wants to ask the PT
  //
  // Backend creates a PT session with status REQUESTED.
  // This is not a confirmed booking yet.
  // ─────────────────────────────────────────────────────────────

  Future<PtBookingResponseModel> requestBooking(
      PtBookingRequestModel request,
      ) async {
    final headers = await _authHeaders();

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/pt-sessions/request');

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      final decodedBody = _decodeBody(response);

      debugPrint('PT BOOKING REQUEST STATUS: ${response.statusCode}');
      debugPrint('PT BOOKING REQUEST BODY: $decodedBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PtBookingResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('PT BOOKING REQUEST ERROR: $e');
      debugPrint('PT BOOKING REQUEST STACK: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST /api/member/pt-package-bookings
  // ─────────────────────────────────────────────────────────────

  Future<PtPackageBookingResponseModel> createPackageBooking(
      PtPackageBookingRequestModel request,
      ) async {
    final headers = await _authHeaders();

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/pt-package-bookings',
    );

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      final decodedBody = _decodeBody(response);

      debugPrint('PACKAGE BOOKING STATUS: ${response.statusCode}');
      debugPrint('PACKAGE BOOKING BODY: $decodedBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PtPackageBookingResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('PACKAGE BOOKING ERROR: $e');
      debugPrint('PACKAGE BOOKING STACK: $stackTrace');
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GET /api/member/payment-methods
  // ─────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/member/payment-methods');

    try {
      final response = await _client.get(uri, headers: headers);
      final decodedBody = _decodeBody(response);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(decodedBody);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
        return const [];
      }

      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();

      throw ServerException(message: decodedBody);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST /api/member/pt-package-bookings/{id}/confirm-payment
  // Called after Stripe presentPaymentSheet() succeeds.
  // ─────────────────────────────────────────────────────────────

  Future<PtPackageBookingResponseModel> confirmPackagePayment(int bookingId) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/pt-package-bookings/$bookingId/confirm-payment',
    );

    try {
      final response = await _client.post(uri, headers: headers);
      final decodedBody = _decodeBody(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PtPackageBookingResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();

      throw ServerException(message: decodedBody);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST /api/member/pt-package-bookings/{id}/check-status
  // Used for PayPal / MPGS redirect payments.
  // ─────────────────────────────────────────────────────────────

  Future<PtPackageBookingResponseModel> checkPackagePaymentStatus(int bookingId) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/pt-package-bookings/$bookingId/check-status',
    );

    try {
      final response = await _client.post(uri, headers: headers);
      final decodedBody = _decodeBody(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PtPackageBookingResponseModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();

      throw ServerException(message: decodedBody);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}