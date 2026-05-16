// lib/features/admin/payment_settings/data/services/admin_payment_settings_service.dart

import 'dart:convert';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/apt_fetch.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/network/authed_http_client.dart';
import '../../../../auth/data/services/admin_token_store.dart';

class AdminPaymentSettingsService {
  final _client = AuthedHttpClient();
  final AdminTokenStore _tokenStore;

  AdminPaymentSettingsService({required AuthTokenStore tokenStore}) :_tokenStore = const AdminTokenStore();

  String get _base => Env.apiProjectBaseUrl;

  // GET /api/admin/payment-settings
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final token = await _tokenStore.getToken();
    final response = await _client.get(
      Uri.parse('$_base/api/admin/payment-settings'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final List<dynamic> list = jsonDecode(response.body) as List;
    return list.cast<Map<String, dynamic>>();
  }

  // PUT /api/admin/payment-settings/{methodName}
  Future<void> saveConfig({
    required String methodName,
    required bool enabled,
    required Map<String, dynamic> configValues,
  }) async {
    final token = await _tokenStore.getToken();
    await _client.put(
      Uri.parse('$_base/api/admin/payment-settings/$methodName'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'enabled': enabled, 'configValues': configValues}),
    );
  }

  // POST /api/admin/payment-settings/{methodName}/test
  Future<Map<String, dynamic>> testConnection(String methodName) async {
    final token = await _tokenStore.getToken();
    final response = await _client.post(
      Uri.parse('$_base/api/admin/payment-settings/$methodName/test'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
