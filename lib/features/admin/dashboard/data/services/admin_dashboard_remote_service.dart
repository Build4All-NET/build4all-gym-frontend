import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../../../../../core/config/env.dart';
import '../../../../auth/data/services/admin_token_store.dart'; // ← changed
import '../models/admin_dashboard_summary_model.dart';
import '../../../../../core/error/exceptions.dart';

abstract class AdminDashboardRemoteDatasource {
  final _client = AuthedHttpClient();
  Future<AdminDashboardSummaryModel> getDashboardSummary({
    String period = 'today',
    String revenuePeriod = 'this_month',
    String? revenueStartDate,
    String? revenueEndDate,
  });
}

class AdminDashboardRemoteDatasourceImpl implements AdminDashboardRemoteDatasource {
  final _client = AuthedHttpClient();
  final AdminTokenStore _tokenStore; // ← changed

  AdminDashboardRemoteDatasourceImpl()
      : _tokenStore = const AdminTokenStore(); // ← changed

  @override
  Future<AdminDashboardSummaryModel> getDashboardSummary({
    String period = 'today',
    String revenuePeriod = 'this_month',
    String? revenueStartDate,
    String? revenueEndDate,
  }) async {
    final token = await _tokenStore.getToken(); // now reads 'admin_token' key ✅

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/dashboard')
        .replace(queryParameters: {
      'period': period,
      'revenuePeriod': revenuePeriod,
      if (revenueStartDate != null) 'startDate': revenueStartDate,
      if (revenueEndDate != null) 'endDate': revenueEndDate,
    });

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId, // ← add this too
        },
      );

      if (response.statusCode == 200) {
        return AdminDashboardSummaryModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }
}