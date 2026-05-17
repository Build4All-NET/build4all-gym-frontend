// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/services/availability_service.dart
//
// CHANGES vs previous version:
//   - createSlot() now accepts optional `specificDate` (DateTime?) parameter.
//     When provided it is serialised as "specificDate": "yyyy-MM-dd" in the
//     JSON body so the backend can store it in trainer_availability.specific_date.
//     The field is only sent when non-null (recurring = false case).
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/exceptions/auth_exception.dart';
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/availability_model.dart';

class AvailabilityHttpService {
  final _client     = AuthedHttpClient();
  final _tokenStore = const AdminTokenStore();

  static final _dateFmt = DateFormat('yyyy-MM-dd');

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Never _handleError(http.Response r) {
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: utf8.decode(r.bodyBytes));
  }

  // ── GET ───────────────────────────────────────────────────────────────────

  Future<List<AvailabilityModel>> getSlots({
    int? trainerId,
    required int branchId,
  }) async {
    final headers = await _headers();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/availability?branchId=$branchId';
    final uri  = Uri.parse(
        trainerId != null ? '$base&trainerId=$trainerId' : base);
    try {
      final r = await _client.get(uri, headers: headers);
      debugPrint('GET AVAILABILITY: ${r.statusCode}');
      if (r.statusCode == 200) {
        final list = jsonDecode(utf8.decode(r.bodyBytes)) as List<dynamic>;
        return list
            .map((e) => AvailabilityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── POST ──────────────────────────────────────────────────────────────────
  //
  // Body fields (all mapped from DB trainer_availability columns):
  //   trainerId    → trainer_id
  //   branchId     → branch_id
  //   weekday      → weekday        (1=Mon … 7=Sun)
  //   startTime    → start_time     ("HH:mm")
  //   endTime      → end_time       ("HH:mm")
  //   recurring    → is_recurring
  //   specificDate → specific_date  (only when recurring = false)

  Future<AvailabilityModel> createSlot({
    required int trainerId,
    required int branchId,
    required int weekday,
    required String startTime, // "HH:mm"
    required String endTime,
    bool recurring = true,
    DateTime? specificDate,    // ← NEW: only non-null when recurring=false
  }) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/availability');

    final body = <String, dynamic>{
      'trainerId': trainerId,
      'branchId':  branchId,
      'weekday':   weekday,
      'startTime': startTime,
      'endTime':   endTime,
      'recurring': recurring,
      // Only include specificDate when non-null (non-recurring slot)
      if (!recurring && specificDate != null)
        'specificDate': _dateFmt.format(specificDate),
    };

    try {
      final r = await _client.post(uri, headers: headers, body: jsonEncode(body));
      debugPrint('CREATE AVAILABILITY: ${r.statusCode}');
      if (r.statusCode == 200 || r.statusCode == 201) {
        return AvailabilityModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  Future<void> deleteSlot(int availabilityId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/trainer/availability/$availabilityId');
    try {
      final r = await _client.delete(uri, headers: headers);
      if (r.statusCode == 204) return;
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}
