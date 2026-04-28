import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/adminplanstatsmodel.dart';
import '../models/adminplanlistitemmodel.dart';
import '../models/AdminBranchOptionModel.dart';
import '../models/createplanrequestmodel.dart';
import '../models/updateplanrequestmodel.dart';
import '../../../../../core/config/env.dart' as ENV;

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
  final _storage = const FlutterSecureStorage();

  // Replace with your actual base URL / ApiClient pattern
  static const String _baseUrl = ENV.Env.apiProjectBaseUrl;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── GET /api/admin/plans/stats ─────────────────────────────────────────────
  @override
  Future<AdminPlanStatsModel> getStats() async {
    final headers = await _authHeaders();
    final response = await http.get(
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

    final response = await http.get(uri, headers: headers);
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
    final response = await http.get(
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
    final response = await http.get(
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
    final response = await http.post(
      Uri.parse('$_baseUrl/api/admin/plans'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    // Expect 201 Created
    if (response.statusCode != 201 && response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(body?['message'] ?? 'Failed to create plan');
    }
  }

  // ── PUT /api/admin/plans/{planId} ─────────────────────────────────────────
  @override
  Future<void> updatePlan(int planId, UpdatePlanRequestModel request) async {
    final headers = await _authHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/api/admin/plans/$planId'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    _checkStatus(response);
  }

  // ── DELETE /api/admin/plans/{planId} ──────────────────────────────────────
  @override
  Future<void> deletePlan(int planId) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/admin/plans/$planId'),
      headers: headers,
    );
    // 400 = business rule block (e.g. active members exist) — surface message
    if (response.statusCode == 400) {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(body?['message'] ?? 'Cannot delete plan');
    }
    _checkStatus(response);
  }

  // ── Private helper ────────────────────────────────────────────────────────
  void _checkStatus(http.Response response) {
    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(body?['message'] ?? 'Request failed: ${response.statusCode}');
    }
  }
}