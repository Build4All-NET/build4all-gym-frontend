import 'dart:convert';
import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/employee_checkin_row_model.dart';
import '../models/employee_checkin_action_model.dart';
import '../models/branch_checkin_qr_model.dart';
import '../../../../../core/config/env.dart';

// ── Abstract ──────────────────────────────────────────────────────────────────

abstract class EmployeeCheckinsRemoteDatasource {
  Future<List<EmployeeCheckinRowModel>> getTodayCheckins({required int branchId});
  Future<BranchCheckinQrModel> getBranchQr({required int branchId});
  Future<EmployeeCheckinActionModel> scan({required String token});
  Future<EmployeeCheckinActionModel> manualCheckin({required int employeeId});
  Future<EmployeeCheckinActionModel> manualCheckout({required int employeeCheckinId});
}

// ── Implementation ────────────────────────────────────────────────────────────

class EmployeeCheckinsRemoteDatasourceImpl implements EmployeeCheckinsRemoteDatasource {
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

  // ── GET /api/admin/employees/checkins/today?branchId= ──────────────────────
  @override
  Future<List<EmployeeCheckinRowModel>> getTodayCheckins({required int branchId}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$_baseUrl/api/admin/employees/checkins/today')
        .replace(queryParameters: {'branchId': branchId.toString()});

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => EmployeeCheckinRowModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── GET /api/admin/employees/checkins/qr?branchId= ──────────────────────────
  @override
  Future<BranchCheckinQrModel> getBranchQr({required int branchId}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$_baseUrl/api/admin/employees/checkins/qr')
        .replace(queryParameters: {'branchId': branchId.toString()});

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);
    return BranchCheckinQrModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── POST /api/admin/employees/checkins/scan ─────────────────────────────────
  @override
  Future<EmployeeCheckinActionModel> scan({required String token}) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/employees/checkins/scan'),
      headers: headers,
      body: jsonEncode({'token': token}),
    );
    _checkStatus(response);
    return EmployeeCheckinActionModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── POST /api/admin/employees/checkins/{employeeId}/manual-checkin ─────────
  @override
  Future<EmployeeCheckinActionModel> manualCheckin({required int employeeId}) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/employees/checkins/$employeeId/manual-checkin'),
      headers: headers,
    );
    _checkStatus(response);
    return EmployeeCheckinActionModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── PATCH /api/admin/employees/checkins/{employeeCheckinId}/checkout ───────
  @override
  Future<EmployeeCheckinActionModel> manualCheckout({required int employeeCheckinId}) async {
    final headers = await _authHeaders();
    final response = await _client.patch(
      Uri.parse('$_baseUrl/api/admin/employees/checkins/$employeeCheckinId/checkout'),
      headers: headers,
    );
    _checkStatus(response);
    return EmployeeCheckinActionModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
