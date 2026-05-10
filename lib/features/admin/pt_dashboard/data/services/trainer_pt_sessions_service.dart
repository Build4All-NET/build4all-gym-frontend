// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/services/trainer_pt_sessions_service.dart
// LAYER: Data — HTTP calls only, no domain logic
//
// Endpoints:
//   GET    /api/trainer/pt-sessions?branchId=&date=       → session list
//   GET    /api/trainer/pt-sessions/stats?branchId=&date= → stats cards
//   POST   /api/trainer/pt-sessions                       → create session
//   PATCH  /api/trainer/pt-sessions/{id}/status           → update status
//
// Auth: JWT from FlutterSecureStorage via _authHeaders().
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/exceptions/server_exception.dart';
import '../../../../../core/exceptions/unauthorized_exception.dart';
import '../../../../../core/exceptions/forbidden_exception.dart';
import '../../../../../core/exceptions/network_exception.dart';
import '../models/pt_session_model.dart';
import '../models/pt_session_stats_model.dart';

class TrainerPtSessionsService {
  final _storage = const FlutterSecureStorage();

  static final _dateFmt = DateFormat('yyyy-MM-dd');

  // ── Auth headers ─────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── Response body decoder ─────────────────────────────────────────────────

  String _decodeBody(http.Response response) =>
      utf8.decode(response.bodyBytes);

  // ── Shared error handler ──────────────────────────────────────────────────
  // Always throws — callers don't need to rethrow after calling this.

  Never _handleError(http.Response response) {
    final body = _decodeBody(response);
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: body);
  }

  // ── GET sessions by date ──────────────────────────────────────────────────

  Future<List<PtSessionModel>> getSessionsByDate({
    required int branchId,
    required DateTime date,
  }) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions'
      '?branchId=$branchId&date=${_dateFmt.format(date)}',
    );

    try {
      final response = await http.get(uri, headers: headers);
      debugPrint('GET SESSIONS STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        final data = decoded['data'] as List<dynamic>;
        return data
            .map((e) => PtSessionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── GET stats by date ─────────────────────────────────────────────────────

  Future<PtSessionStatsModel> getStatsByDate({
    required int branchId,
    required DateTime date,
  }) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/stats'
      '?branchId=$branchId&date=${_dateFmt.format(date)}',
    );

    try {
      final response = await http.get(uri, headers: headers);
      debugPrint('GET STATS STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionStatsModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── POST create session ───────────────────────────────────────────────────

  Future<PtSessionModel> createSession(Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/pt-sessions');

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint('CREATE SESSION STATUS: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded =
            jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH update status ───────────────────────────────────────────────────

  Future<PtSessionModel> updateStatus(int sessionId, String status) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/$sessionId/status',
    );

    try {
      final response = await http.patch(
        uri,
        headers: headers,
        body: jsonEncode({'status': status}),
      );
      debugPrint('UPDATE STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded =
            jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}
