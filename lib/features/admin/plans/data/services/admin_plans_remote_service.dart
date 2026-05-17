

import 'dart:convert';
import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/AdminBranchOptionModel.dart';
import '../models/AdminPlanStatsModel.dart';
import '../models/AdminPlanListItemModel.dart';
import '../models/CreatePlanRequestModel.dart';
import '../models/UpdatePlanRequestModel.dart';
import '../../../../../core/config/env.dart';

// ── Abstract ──────────────────────────────────────────────────────────────────

abstract class AdminPlansRemoteDatasource {
  Future<AdminPlanStatsModel> getStats();
  Future<List<AdminPlanListItemModel>> getPlans({String? type, String? search});
  Future<List<String>> getPlanTypes();
  Future<List<AdminBranchOptionModel>> getBranches();
  Future<void> createPlan(CreatePlanRequestModel request);
  Future<void> updatePlan(int planId, UpdatePlanRequestModel request);
  Future<void> deletePlan(int planId);
}

// ── Implementation ────────────────────────────────────────────────────────────

class AdminPlansRemoteDatasourceImpl implements AdminPlansRemoteDatasource {
  final _client = AuthedHttpClient();

  final _tokenStore = const AdminTokenStore();

  static const String _baseUrl = Env.apiProjectBaseUrl;

  Future<Map<String, String>> _authHeaders() async {

    final token = await _tokenStore.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── GET /api/admin/plans/stats ─────────────────────────────────────────────
  @override
  Future<AdminPlanStatsModel> getStats() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/plans/stats'),
      headers: headers,
    );
    _checkStatus(response);
    return AdminPlanStatsModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── GET /api/admin/plans?type=&search= ────────────────────────────────────
  @override
  Future<List<AdminPlanListItemModel>> getPlans(
      {String? type, String? search}) async {
    final headers = await _authHeaders();
    final queryParams = <String, String>{};
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse('$_baseUrl/api/admin/plans')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => AdminPlanListItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── GET /api/admin/plans/types ─────────────────────────────────────────────
  @override
  Future<List<String>> getPlanTypes() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/plans/types'),
      headers: headers,
    );
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }

  // ── GET /api/admin/plans/branches ─────────────────────────────────────────
  @override
  Future<List<AdminBranchOptionModel>> getBranches() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/plans/branches'),
      headers: headers,
    );
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => AdminBranchOptionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

// ── POST /api/admin/plans ─────────────────────────────────────────────────
  @override
  Future<void> createPlan(CreatePlanRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/plans'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      String? message;
      if (response.body.isNotEmpty) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>?;
          message = body?['message'] as String?;
        } catch (_) {
          message = response.body;
        }
      }
      throw Exception(message ?? 'Failed to create plan');
    }
  }

  // ── PUT /api/admin/plans/{planId} ─────────────────────────────────────────
  @override
  Future<void> updatePlan(int planId, UpdatePlanRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.put(
      Uri.parse('$_baseUrl/api/admin/plans/$planId'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    _checkStatus(response);
  }

// ── DELETE ────────────────────────────────────────────────────────────────
  @override
  Future<void> deletePlan(int planId) async {
    final headers = await _authHeaders();
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/admin/plans/$planId'),
      headers: headers,
    );
    if (response.statusCode == 400) {
      String? message;
      if (response.body.isNotEmpty) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>?;
          message = body?['message'] as String?;
        } catch (_) {
          message = response.body;
        }
      }
      throw Exception(message ?? 'Cannot delete plan');
    }
    _checkStatus(response);
  }

  // ── Private helper ────────────────────────────────────────────────────────
  // ── Private helper ────────────────────────────────────────────────────────
  void _checkStatus(http.Response response) {
    if (response.statusCode >= 400) {
      String? message;
      if (response.body.isNotEmpty) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>?;
          message = body?['message'] as String?;
        } catch (_) {
          // body wasn't valid JSON (e.g. plain-text or HTML error page)
          message = response.body;
        }
      }
      throw Exception(message ?? 'Request failed: ${response.statusCode}');
    }
  }
}
