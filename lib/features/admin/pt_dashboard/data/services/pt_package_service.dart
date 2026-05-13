import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/pt_package_model.dart';

class PtPackageService {
  final _client = AuthedHttpClient();
  final _tokenStore = const AdminTokenStore();


  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Never _handleError(http.Response r) {
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: utf8.decode(r.bodyBytes));
  }

  Future<List<PtPackageModel>> getPackages({
    int? trainerId,
    required int tenantId,
    required int branchId,
  }) async {
    final headers = await _headers();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/packages'
        '?tenantId=$tenantId&branchId=$branchId';
    final uri = Uri.parse(
      trainerId != null ? '$base&trainerId=$trainerId' : base,
    );
    try {
      final r = await _client.get(uri, headers: headers);
      debugPrint('GET PACKAGES: ${r.statusCode}');
      if (r.statusCode == 200) {
        final list = jsonDecode(utf8.decode(r.bodyBytes)) as List<dynamic>;
        return list
            .map((e) => PtPackageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  Future<PtPackageModel> createPackage({
    required int trainerId,
    required int tenantId,
    required int branchId,
    required Map<String, dynamic> body,
  }) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/packages');
    try {
      final r = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({...body, 'trainerId': trainerId, 'tenantId': tenantId, 'branchId': branchId}),
      );
      debugPrint('CREATE PACKAGE: ${r.statusCode}');
      if (r.statusCode == 200 || r.statusCode == 201) {
        return PtPackageModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  Future<PtPackageModel> updatePackage(int id, Map<String, dynamic> body) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/packages/$id');
    try {
      final r = await _client.put(uri, headers: headers, body: jsonEncode(body));
      if (r.statusCode == 200) {
        return PtPackageModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  Future<void> deactivatePackage(int id) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/packages/$id');
    try {
      final r = await _client.delete(uri, headers: headers);
      if (r.statusCode == 204) return;
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}