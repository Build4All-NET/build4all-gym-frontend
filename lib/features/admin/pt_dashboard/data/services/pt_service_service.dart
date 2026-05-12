import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/pt_service_model.dart';

class PtServiceService {
  final _client = AuthedHttpClient();
  final _tokenStore = const AdminTokenStore();


  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Never _handleError(http.Response r) {
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: utf8.decode(r.bodyBytes));
  }

  Future<List<PtServiceModel>> getServices(int tenantId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/trainer/services?tenantId=$tenantId');
    try {
      final r = await _client.get(uri, headers: headers);
      debugPrint('GET SERVICES: ${r.statusCode}');
      if (r.statusCode == 200) {
        final list = jsonDecode(utf8.decode(r.bodyBytes)) as List<dynamic>;
        return list.map((e) => PtServiceModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  Future<PtServiceModel> createService(int tenantId, Map<String, dynamic> body) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/services');
    try {
      final r = await _client.post(uri, headers: headers,
          body: jsonEncode({...body, 'tenantId': tenantId}));
      debugPrint('CREATE SERVICE: ${r.statusCode}');
      if (r.statusCode == 200 || r.statusCode == 201) {
        return PtServiceModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}