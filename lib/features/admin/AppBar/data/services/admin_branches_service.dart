// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/shared/data/services/admin_branches_service.dart
//
// CHANGE: GET /api/admin/branches  →  GET /api/admin/branches/options
//
// WHY:
//   GET /api/admin/branches now returns AdminBranchListResponse (stats + full
//   branch cards) for the Branches Management screen.
//   GET /api/admin/branches/options is the slim backward-compat endpoint that
//   still returns [ { "id": "uuid", "name": "..." }, … ] — exactly what the
//   AppBar branch picker needs.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/branch_option_model.dart';

class AdminBranchesService {
  final _client = AuthedHttpClient();
  final AdminTokenStore _tokenStore;

  AdminBranchesService() : _tokenStore = const AdminTokenStore();

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
    throw ServerException(
        message: 'HTTP ${response.statusCode}: ${response.body}');
  }

  // ── GET /api/admin/branches/options ──────────────────────────────────────
  // Returns slim active-branch list for the AppBar branch picker.
  // Response: [ { "id": "uuid-string", "name": "Branch Name" }, … ]
  Future<List<BranchOptionModel>> getBranches() async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/branches/options');

    try {
      final response = await _client.get(uri, headers: headers);
      _handleStatus(response);

      final rawList = jsonDecode(response.body) as List<dynamic>;
      return rawList
          .map((e) => BranchOptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}