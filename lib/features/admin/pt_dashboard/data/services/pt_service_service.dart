// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/services/pt_service_service.dart
// LAYER: Data — Remote Service (HTTP only)
//
// CHANGES vs old version:
//   - getServices() now accepts optional trainerId (null = all trainers)
//   - createService() now accepts trainerId to assign service to trainer
//   - deleteService() added (calls DELETE /api/trainer/services/{id})
// =============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:build4allgym/core/network/authed_http_client.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/pt_service_model.dart';

class PtServiceService {
  final _client     = AuthedHttpClient();
  final _tokenStore = const AdminTokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    return {
      'Content-Type':  'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Never _handleError(http.Response r) {
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: utf8.decode(r.bodyBytes));
  }

  // ── GET /api/trainer/services ─────────────────────────────────────────────
  /// [trainerId] = null → returns services for ALL trainers in the tenant (admin view).
  Future<List<PtServiceModel>> getServices({
    int? trainerId,
    required int tenantId,
  }) async {
    final headers = await _headers();
    String url =
        '${Env.apiProjectBaseUrl}/api/trainer/services?tenantId=$tenantId';
    if (trainerId != null) url += '&trainerId=$trainerId';

    final uri = Uri.parse(url);
    try {
      final r = await _client.get(uri, headers: headers);
      debugPrint('GET SERVICES: ${r.statusCode}');

      if (r.statusCode == 200) {
        final list = jsonDecode(utf8.decode(r.bodyBytes)) as List<dynamic>;
        return list
            .map((e) => PtServiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
    // unreachable — _handleError always throws, but Dart requires a return
    throw NetworkException();
  }

  // ── POST /api/trainer/services ────────────────────────────────────────────
  Future<PtServiceModel> createService({
    required int trainerId,
    required int tenantId,
    required Map<String, dynamic> body,
  }) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/services');
    try {
      final r = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({
          ...body,
          'trainerId': trainerId,
          'tenantId':  tenantId,
        }),
      );
      debugPrint('CREATE SERVICE: ${r.statusCode}');

      if (r.statusCode == 200 || r.statusCode == 201) {
        return PtServiceModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
    throw NetworkException();
  }

  // ── PUT /api/trainer/services/{id} ────────────────────────────────────────
  Future<PtServiceModel> updateService(
      int id,
      Map<String, dynamic> body,
      ) async {
    final headers = await _headers();
    final uri =
    Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/services/$id');
    try {
      final r = await _client.put(uri, headers: headers, body: jsonEncode(body));
      debugPrint('UPDATE SERVICE: ${r.statusCode}');

      if (r.statusCode == 200) {
        return PtServiceModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
    throw NetworkException();
  }

  // ── DELETE /api/trainer/services/{id} ────────────────────────────────────
  Future<void> deleteService(int id) async {
    final headers = await _headers();
    final uri =
    Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/services/$id');
    try {
      final r = await _client.delete(uri, headers: headers);
      debugPrint('DELETE SERVICE: ${r.statusCode}');

      if (r.statusCode == 204 || r.statusCode == 200) return;
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}