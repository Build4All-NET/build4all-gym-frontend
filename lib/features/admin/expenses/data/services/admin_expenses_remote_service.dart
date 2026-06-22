import 'dart:convert';
import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/expense_model.dart';
import '../models/expense_stats_model.dart';
import '../models/create_expense_request_model.dart';
import '../models/update_expense_request_model.dart';
import '../../../../../core/config/env.dart';

// ── Abstract ──────────────────────────────────────────────────────────────────

abstract class AdminExpensesRemoteDatasource {
  Future<ExpenseStatsModel> getStats();
  Future<List<ExpenseModel>> getExpenses({int? branchId, String? category, String? search});
  Future<List<String>> getCategories();
  Future<void> createExpense(CreateExpenseRequestModel request);
  Future<void> updateExpense(int expenseId, UpdateExpenseRequestModel request);
  Future<void> deleteExpense(int expenseId);
  Future<ExpenseModel> confirmTrainerPaid(int expenseId);
}

// ── Implementation ────────────────────────────────────────────────────────────

class AdminExpensesRemoteDatasourceImpl implements AdminExpensesRemoteDatasource {
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

  // ── GET /api/admin/expenses/stats ───────────────────────────────────────────
  @override
  Future<ExpenseStatsModel> getStats() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/expenses/stats'),
      headers: headers,
    );
    _checkStatus(response);
    return ExpenseStatsModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── GET /api/admin/expenses?branchId=&category=&search= ────────────────────
  @override
  Future<List<ExpenseModel>> getExpenses(
      {int? branchId, String? category, String? search}) async {
    final headers = await _authHeaders();
    final queryParams = <String, String>{};
    if (branchId != null) queryParams['branchId'] = branchId.toString();
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse('$_baseUrl/api/admin/expenses')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── GET /api/admin/expenses/categories ──────────────────────────────────────
  @override
  Future<List<String>> getCategories() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/expenses/categories'),
      headers: headers,
    );
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }

  // ── POST /api/admin/expenses ─────────────────────────────────────────────────
  @override
  Future<void> createExpense(CreateExpenseRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/expenses'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_extractMessage(response) ?? 'Failed to create expense');
    }
  }

  // ── PUT /api/admin/expenses/{expenseId} ─────────────────────────────────────
  @override
  Future<void> updateExpense(int expenseId, UpdateExpenseRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.put(
      Uri.parse('$_baseUrl/api/admin/expenses/$expenseId'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    _checkStatus(response);
  }

  // ── DELETE /api/admin/expenses/{expenseId} ──────────────────────────────────
  @override
  Future<void> deleteExpense(int expenseId) async {
    final headers = await _authHeaders();
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/admin/expenses/$expenseId'),
      headers: headers,
    );
    if (response.statusCode == 400) {
      throw Exception(_extractMessage(response) ?? 'Cannot delete expense');
    }
    _checkStatus(response);
  }

  // ── POST /api/admin/expenses/{expenseId}/confirm-trainer-paid ──────────────
  @override
  Future<ExpenseModel> confirmTrainerPaid(int expenseId) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/expenses/$expenseId/confirm-trainer-paid'),
      headers: headers,
    );
    _checkStatus(response);
    return ExpenseModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── Private helpers ──────────────────────────────────────────────────────────
  String? _extractMessage(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      return body?['message'] as String?;
    } catch (_) {
      return response.body;
    }
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception(_extractMessage(response) ?? 'Request failed: ${response.statusCode}');
    }
  }
}
