// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/services/trainer_pt_sessions_service.dart
// LAYER: Data — HTTP calls only, no domain logic
//
// Endpoints:
//   GET    /api/trainer/pt-services?branchId=&date=       → session list
//   GET    /api/trainer/pt-services/stats?branchId=&date= → stats cards
//   POST   /api/trainer/pt-services                       → create session
//   PATCH  /api/trainer/pt-services/{id}/status           → update status
//
// Auth: JWT from FlutterSecureStorage via _authHeaders().
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/pt_session_model.dart';
import '../models/pt_session_stats_model.dart';

class TrainerPtSessionsService {
  final _client = AuthedHttpClient();
  static final _dateFmt = DateFormat('yyyy-MM-dd');

  // ── Base headers (Authorization injected by AuthedHttpClient) ─────────────
  Map<String, String> _authHeaders() => const {
    'Content-Type': 'application/json',
  };

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

  // ── GET services by date ──────────────────────────────────────────────────

  Future<List<PtSessionModel>> getSessionsByDate({
    required int branchId,
    int? trainerId,
    required DateTime date,
  }) async {
    final headers = _authHeaders();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions'
        '?branchId=$branchId&date=${_dateFmt.format(date)}';
    final uri = Uri.parse(
      trainerId != null ? '$base&trainerId=$trainerId' : base,
    );

    try {
      final response = await _client.get(uri, headers: headers);
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
    int? trainerId,
    required DateTime date,
  }) async {
    final headers = _authHeaders();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/stats'
        '?branchId=$branchId&date=${_dateFmt.format(date)}';
    final uri = Uri.parse(
      trainerId != null ? '$base&trainerId=$trainerId' : base,
    );

    try {
      final response = await _client.get(uri, headers: headers);
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

  Future<PtSessionModel> createSession(Map<String, dynamic> body, {int? trainerId}) async {
    final headers = _authHeaders();
    final baseUrl = '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions';
    final uri = Uri.parse(trainerId != null ? '$baseUrl?trainerId=$trainerId' : baseUrl);

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);
      debugPrint(body.toString());
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

  // ── GET all upcoming sessions (from now, no date filter) ─────────────────

  Future<List<PtSessionModel>> getUpcoming({
    required int branchId,
    int? trainerId,
  }) async {
    final headers = _authHeaders();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/upcoming'
        '?branchId=$branchId';
    final uri = Uri.parse(
      trainerId != null ? '$base&trainerId=$trainerId' : base,
    );

    try {
      final response = await _client.get(uri, headers: headers);
      debugPrint('GET UPCOMING STATUS: ${response.statusCode}');

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

  // ── GET all REQUESTED sessions (no date filter) ──────────────────────────

  Future<List<PtSessionModel>> getRequests({
    required int branchId,
    int? trainerId,
  }) async {
    final headers = _authHeaders();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/requests'
        '?branchId=$branchId';
    final uri = Uri.parse(
      trainerId != null ? '$base&trainerId=$trainerId' : base,
    );

    try {
      final response = await _client.get(uri, headers: headers);
      debugPrint('GET REQUESTS STATUS: ${response.statusCode}');

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

  // ── PATCH accept REQUESTED session ───────────────────────────────────────

  Future<PtSessionModel> acceptRequest(int sessionId) async {
    final headers = _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/$sessionId/accept',
    );

    try {
      final response = await _client.patch(uri, headers: headers);
      debugPrint('ACCEPT REQUEST STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH decline REQUESTED session ──────────────────────────────────────

  Future<PtSessionModel> declineRequest(int sessionId) async {
    final headers = _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/$sessionId/decline',
    );

    try {
      final response = await _client.patch(uri, headers: headers);
      debugPrint('DECLINE REQUEST STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH decline cancel request (CANCEL_REQUESTED → SCHEDULED) ─────────

  Future<PtSessionModel> declineCancelRequest(int sessionId) async {
    final headers = _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/$sessionId/decline-cancel',
    );

    try {
      final response = await _client.patch(uri, headers: headers);
      debugPrint('DECLINE CANCEL REQUEST STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH mark payment status (Admin/Owner/Manager only) ─────────────────
  //
  // Used for standalone (non-package) sessions: records that cash/charge
  // was collected at the office for that one-off session.

  Future<PtSessionModel> markPaymentPaid(int sessionId) async {
    final headers = _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/$sessionId/payment-status',
    );

    try {
      final response = await _client.patch(
        uri,
        headers: headers,
        body: jsonEncode({'paymentStatus': 'PAID'}),
      );
      debugPrint('MARK PAID STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return PtSessionModel.fromJson(decoded['data'] as Map<String, dynamic>);
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
    final headers = _authHeaders();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainer/pt-sessions/$sessionId/status',
    );

    try {
      final response = await _client.patch(
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
