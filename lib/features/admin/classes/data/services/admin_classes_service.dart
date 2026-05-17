// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/services/admin_classes_service.dart
//
// PURPOSE:
//   Makes ALL HTTP calls for the admin classes feature.
//   Pattern: same as AdminMembersService — uses http package directly
//   with AdminTokenStore for JWT and Env.apiProjectBaseUrl for the base URL.
//
// BASE PATH: /api/admin/classes
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/admin_class_list_response_model.dart';
import '../models/cancel_class_request_model.dart';
import '../models/class_form_options_model.dart';
import '../models/create_class_request_model.dart';
import '../models/session_booking_item_model.dart';
import '../models/update_class_request_model.dart';

class AdminClassesService {
  final _client = AuthedHttpClient();
  final AdminTokenStore _tokenStore;

  // ── Constructor ─────────────────────────────────────────────────────────────
  // const constructor so it can be created inline anywhere (same as other services)
  AdminClassesService() : _tokenStore = const AdminTokenStore();

  // ── Shared: build auth headers ──────────────────────────────────────────────
  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization':           'Bearer $token',
      'Content-Type':            'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  // ── Shared: status code guard ───────────────────────────────────────────────
  void _handleStatus(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) return;
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    throw ServerException(
        message: 'HTTP ${response.statusCode}: ${response.body}');
  }

  // ── GET /api/admin/classes ──────────────────────────────────────────────────
  // Returns class cards for a given date (or today if date omitted).
  // branchId is optional — null means "all branches".
  Future<AdminClassListResponseModel> getClassesByDate(
      String? date, int? branchId) async {
    final headers = await _headers();

    // Build query params — only add keys that have values
    final params = <String, String>{};
    if (date != null)     params['date']     = date;
    if (branchId != null) params['branchId'] = branchId.toString();

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/classes')
        .replace(queryParameters: params.isEmpty ? null : params);

    try {
      final response = await _client.get(uri, headers: headers);
      _handleStatus(response);
      return AdminClassListResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── GET /api/admin/classes/form-options ────────────────────────────────────
  // Returns all dropdown data for the Add/Edit Class form.
  Future<ClassFormOptionsModel> getClassFormOptions(int? branchId) async {
    final headers = await _headers();

    final params = <String, String>{};
    if (branchId != null) params['branchId'] = branchId.toString();

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/classes/form-options')
        .replace(queryParameters: params.isEmpty ? null : params);

    try {
      final response = await _client.get(uri, headers: headers);
      _handleStatus(response);
      return ClassFormOptionsModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── POST /api/admin/classes ────────────────────────────────────────────────
  // Creates a new class session. Returns the new sessionId from the response body.
  Future<int> createClass(CreateClassRequestModel request) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/classes');

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );
      _handleStatus(response);

      // BE returns { "sessionId": 42 }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['sessionId'] as int;
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PUT /api/admin/classes/{sessionId} ─────────────────────────────────────
  // Partial update — only sends non-null fields.
  Future<void> updateClass(
      int sessionId, UpdateClassRequestModel request) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/classes/$sessionId');

    try {
      final response = await _client.put(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH /api/admin/classes/{sessionId}/cancel ────────────────────────────
  // Cancels a class session. cancelReason in body is optional.
  Future<void> cancelClass(
      int sessionId, CancelClassRequestModel request) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/classes/$sessionId/cancel');

    try {
      final response = await _client.patch(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH /api/admin/classes/{sessionId}/reactivate ───────────────────────
  // Reverts a cancelled session back to SCHEDULED.
  Future<void> reactivateClass(int sessionId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/classes/$sessionId/reactivate');

    try {
      final response = await _client.patch(
        uri,
        headers: headers,
        body: '{}',
      );
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── GET /api/admin/classes/{sessionId}/bookings ────────────────────────────
  // Returns all BOOKED + WAITLISTED members for a session.
  Future<List<SessionBookingItemModel>> getSessionBookings(
      int sessionId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/classes/$sessionId/bookings');

    try {
      final response = await _client.get(uri, headers: headers);
      _handleStatus(response);

      final rawList = jsonDecode(response.body) as List<dynamic>;
      return rawList
          .map((e) =>
          SessionBookingItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      print('🔴 raw error type: ${e.runtimeType}');
      print('🔴 raw error: $e');
      print(stack);
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}