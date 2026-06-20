import 'dart:convert';
import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/financial_report_model.dart';
import '../models/attendance_report_model.dart';
import '../../../../../core/config/env.dart';

// ── Abstract ──────────────────────────────────────────────────────────────────

abstract class AdminReportsRemoteDatasource {
  Future<FinancialReportModel> getFinancial({DateTime? from, DateTime? to});
  Future<AttendanceReportModel> getAttendance({DateTime? from, DateTime? to});
}

// ── Implementation ────────────────────────────────────────────────────────────

class AdminReportsRemoteDatasourceImpl implements AdminReportsRemoteDatasource {
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

  /// Backend expects inclusive ISO dates (yyyy-MM-dd).
  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Map<String, String> _rangeParams(DateTime? from, DateTime? to) {
    final params = <String, String>{};
    if (from != null) params['from'] = _isoDate(from);
    if (to != null) params['to'] = _isoDate(to);
    return params;
  }

  // ── GET /api/admin/reports/financial?from=&to= ──────────────────────────────
  @override
  Future<FinancialReportModel> getFinancial({DateTime? from, DateTime? to}) async {
    final headers = await _authHeaders();
    final params = _rangeParams(from, to);
    final uri = Uri.parse('$_baseUrl/api/admin/reports/financial')
        .replace(queryParameters: params.isEmpty ? null : params);

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);
    return FinancialReportModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── GET /api/admin/reports/attendance?from=&to= ─────────────────────────────
  @override
  Future<AttendanceReportModel> getAttendance({DateTime? from, DateTime? to}) async {
    final headers = await _authHeaders();
    final params = _rangeParams(from, to);
    final uri = Uri.parse('$_baseUrl/api/admin/reports/attendance')
        .replace(queryParameters: params.isEmpty ? null : params);

    final response = await _client.get(uri, headers: headers);
    _checkStatus(response);
    return AttendanceReportModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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
      throw Exception(
          _extractMessage(response) ?? 'Request failed: ${response.statusCode}');
    }
  }
}
