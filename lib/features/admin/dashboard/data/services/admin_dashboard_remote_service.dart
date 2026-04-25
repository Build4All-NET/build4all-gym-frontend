import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/env.dart';
import '../../../../auth/data/services/auth_token_store.dart';
import '../models/admin_dashboard_summary_model.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/error/exceptions.dart';


abstract class AdminDashboardRemoteDatasource {
  Future<AdminDashboardSummaryModel> getDashboardSummary({String period = 'today'});
}

class AdminDashboardRemoteDatasourceImpl implements AdminDashboardRemoteDatasource {
  final AuthTokenStore _tokenStore;

  AdminDashboardRemoteDatasourceImpl()
      : _tokenStore = const AuthTokenStore();

  @override
  Future<AdminDashboardSummaryModel> getDashboardSummary({String period = 'today'}) async {
    // ✅ reads from 'auth_token' key — same key BLoC writes to
    final token = await _tokenStore.getToken();

    print('DEBUG admin token: $token'); // remove after testing

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/dashboard')
        .replace(queryParameters: {'period': period});

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
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