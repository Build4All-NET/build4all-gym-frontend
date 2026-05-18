// =============================================================================
// FILE: checkins_remote_data_source.dart
//
// PURPOSE:
//   All raw HTTP calls for the checkins feature live here.
//   Returns raw JSON maps/lists — no domain types here.
//   The repository wraps these calls and handles error mapping.
//
// ENDPOINTS:
//   GET  /api/admin/checkins/today?branchId=&search=
//   POST /api/admin/checkins/scan?branchId=
//   PATCH /api/admin/checkins/{checkinId}/checkout
//   POST  /api/admin/members/{userId}/freeze
//   PATCH /api/admin/members/{userId}/block
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/authed_http_client.dart';
import '../../../../auth/data/services/admin_token_store.dart';

class CheckinsRemoteDataSource {
  final _client     = AuthedHttpClient();
  final _tokenStore = const AdminTokenStore();

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization':           'Bearer $token',
      'Content-Type':            'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  void _handleStatus(http.Response response) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) return;
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: 'HTTP ${response.statusCode}: ${response.body}');
  }

  Map<String, dynamic> _parseMap(http.Response response) {
    if (response.body.isEmpty) {
      throw const ServerException(message: 'Server returned an empty response.');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ServerException(
          message: 'Unexpected response shape: ${decoded.runtimeType}');
    }
    return decoded;
  }

  // ── GET /api/admin/checkins/today?branchId=&search= ───────────────────────
  Future<Map<String, dynamic>> getTodayCheckins({
    required int branchId,
    String? search,
  }) async {
    final headers = await _headers();
    final params  = <String, String>{'branchId': branchId.toString()};
    if (search != null && search.isNotEmpty) params['search'] = search;

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/checkins/today')
        .replace(queryParameters: params);

    try {
      final response = await _client.get(uri, headers: headers);
      _handleStatus(response);
      return _parseMap(response);
    } catch (e) {
      _rethrowOrWrap(e);
      rethrow; // unreachable — dart needs this
    }
  }

  // ── POST /api/admin/checkins/scan?branchId= ───────────────────────────────
  Future<Map<String, dynamic>> scanQr({
    required String token,
    required int    branchId,
  }) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/checkins/scan')
        .replace(queryParameters: {'branchId': branchId.toString()});

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({'token': token}),
      );
      _handleStatus(response);
      return _parseMap(response);
    } catch (e) {
      _rethrowOrWrap(e);
      rethrow;
    }
  }

  // ── PATCH /api/admin/checkins/{checkinId}/checkout ────────────────────────
  Future<Map<String, dynamic>> checkOut(int checkinId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/checkins/$checkinId/checkout');

    try {
      final response = await _client.patch(uri, headers: headers);
      _handleStatus(response);
      return _parseMap(response);
    } catch (e) {
      _rethrowOrWrap(e);
      rethrow;
    }
  }

  // ── POST /api/admin/members/{userId}/freeze ───────────────────────────────
  Future<void> freezeMember({
    required int    userId,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/$userId/freeze');

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'fromDate': fromDate,
          'toDate':   toDate,
          'reason':   reason,
        }),
      );
      _handleStatus(response);
    } catch (e) {
      _rethrowOrWrap(e);
      rethrow;
    }
  }

  // ── PATCH /api/admin/members/{userId}/block ───────────────────────────────
  Future<void> blockMember({required int userId, required String reason}) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/$userId/block');

    try {
      final response = await _client.patch(
        uri,
        headers: headers,
        body: reason.isNotEmpty ? jsonEncode({'reason': reason}) : null,
      );
      _handleStatus(response);
    } catch (e) {
      _rethrowOrWrap(e);
      rethrow;
    }
  }

  // ── Error helper ──────────────────────────────────────────────────────────
  // Rethrowing known exception types preserves their identity so the repo
  // can map them to user-friendly messages. Unknown errors become NetworkException.
  void _rethrowOrWrap(Object e) {
    if (e is UnauthorizedException ||
        e is ForbiddenException ||
        e is ServerException) {
      throw e;
    }

    throw NetworkException();
  }
}
