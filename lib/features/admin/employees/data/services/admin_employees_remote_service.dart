import 'dart:convert';
import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/employee_model.dart';
import '../models/employee_payment_model.dart';
import '../models/eligible_staff_model.dart';
import '../models/create_employee_request_model.dart';
import '../models/update_employee_request_model.dart';
import '../models/pay_employee_request_model.dart';
import '../models/pay_employee_response_model.dart';
import '../../../../../core/config/env.dart';

// ── Abstract ──────────────────────────────────────────────────────────────────

abstract class AdminEmployeesRemoteDatasource {
  Future<List<EmployeeModel>> getEmployees({
    int? branchId,
    String? employeeType,
    String? status,
    String? search,
  });
  Future<List<String>> getTypes();
  Future<List<EligibleStaffModel>> getEligibleStaff();
  Future<EmployeeModel> createEmployee(CreateEmployeeRequestModel request);
  Future<EmployeeModel> updateEmployee(int employeeId, UpdateEmployeeRequestModel request);
  Future<void> deleteEmployee(int employeeId);
  Future<PayEmployeeResponseModel> payEmployee(int employeeId, PayEmployeeRequestModel request);
  Future<List<EmployeePaymentModel>> getPayments(int employeeId);
}

// ── Implementation ────────────────────────────────────────────────────────────

class AdminEmployeesRemoteDatasourceImpl implements AdminEmployeesRemoteDatasource {
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

  // ── GET /api/admin/employees?branchId=&employeeType=&status=&search= ──────
  @override
  Future<List<EmployeeModel>> getEmployees({
    int? branchId,
    String? employeeType,
    String? status,
    String? search,
  }) async {
    final headers = await _authHeaders();
    final queryParams = <String, String>{};
    if (branchId != null) queryParams['branchId'] = branchId.toString();
    if (employeeType != null && employeeType.isNotEmpty) queryParams['employeeType'] = employeeType;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse('$_baseUrl/api/admin/employees')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── GET /api/admin/employees/types ──────────────────────────────────────────
  @override
  Future<List<String>> getTypes() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/employees/types'),
      headers: headers,
    );
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }

  // ── GET /api/admin/employees/eligible-staff ─────────────────────────────────
  @override
  Future<List<EligibleStaffModel>> getEligibleStaff() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/employees/eligible-staff'),
      headers: headers,
    );
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => EligibleStaffModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── POST /api/admin/employees ────────────────────────────────────────────────
  @override
  Future<EmployeeModel> createEmployee(CreateEmployeeRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/employees'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_extractMessage(response) ?? 'Failed to create employee');
    }
    return EmployeeModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── PUT /api/admin/employees/{employeeId} ───────────────────────────────────
  @override
  Future<EmployeeModel> updateEmployee(int employeeId, UpdateEmployeeRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.put(
      Uri.parse('$_baseUrl/api/admin/employees/$employeeId'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    _checkStatus(response);
    return EmployeeModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── DELETE /api/admin/employees/{employeeId} ────────────────────────────────
  @override
  Future<void> deleteEmployee(int employeeId) async {
    final headers = await _authHeaders();
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/admin/employees/$employeeId'),
      headers: headers,
    );
    _checkStatus(response);
  }

  // ── POST /api/admin/employees/{employeeId}/pay ──────────────────────────────
  @override
  Future<PayEmployeeResponseModel> payEmployee(int employeeId, PayEmployeeRequestModel request) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/admin/employees/$employeeId/pay'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    _checkStatus(response);
    return PayEmployeeResponseModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── GET /api/admin/employees/{employeeId}/payments ──────────────────────────
  @override
  Future<List<EmployeePaymentModel>> getPayments(int employeeId) async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/admin/employees/$employeeId/payments'),
      headers: headers,
    );
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => EmployeePaymentModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
