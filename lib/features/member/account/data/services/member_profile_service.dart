import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/authed_http_client.dart';
import '../../../../auth/data/services/auth_token_store.dart';

class MemberProfileService {
  final _client     = AuthedHttpClient();
  final _tokenStore = const AuthTokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type':  'application/json',
    };
  }

  void _handleError(http.Response r) {
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: 'HTTP ${r.statusCode}: ${r.body}');
  }

  Future<Map<String, dynamic>> getProfileStatus() async {
    final headers = await _headers();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/account/profile-status',
    );

    try {
      final r = await _client.get(uri, headers: headers);

      debugPrint('GET profile-status: ${r.statusCode}');
      debugPrint('GET profile-status body: ${utf8.decode(r.bodyBytes)}');

      if (r.statusCode == 200) {
        return jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
      }

      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }

    throw NetworkException();
  }

  // GET /api/member/account/branches
  Future<List<Map<String, dynamic>>> getBranches() async {
    final headers = await _headers();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/account/branches',
    );

    try {
      final r = await _client.get(uri, headers: headers);

      debugPrint('GET branches: ${r.statusCode}');
      debugPrint('GET branches body: ${utf8.decode(r.bodyBytes)}');

      if (r.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(r.bodyBytes));

        if (decoded is List) {
          return decoded
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }

        throw ServerException(
          message: 'Expected List for branches but got: ${decoded.runtimeType}',
        );
      }

      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }

    throw NetworkException();
  }

  // PUT /api/member/account/profile-status
  Future<void> saveProfile(Map<String, dynamic> body) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/member/account/profile-status');
    try {
      final r = await _client.put(uri, headers: headers, body: jsonEncode(body));
      debugPrint('PUT profile-status: ${r.statusCode}');
      if (r.statusCode == 200 || r.statusCode == 204) return;
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}
