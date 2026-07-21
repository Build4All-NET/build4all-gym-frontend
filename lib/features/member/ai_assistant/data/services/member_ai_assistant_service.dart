import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/error/exceptions.dart';
import 'package:build4allgym/core/network/authed_http_client.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

import '../models/member_ai_query_response_model.dart';

// Calls POST /api/member/ai-assistant/query.
//
// This is the member-facing AI assistant — distinct from the owner-side
// gym-analytics assistant. It answers a member's own questions (PT
// sessions, classes, membership, fitness goal) using real backend data,
// never invented numbers.
class MemberAiAssistantService {
  final http.Client _client;
  final AuthTokenStore _tokenStore;

  MemberAiAssistantService({
    http.Client? client,
    AuthTokenStore? tokenStore,
  })  : _client = client ?? AuthedHttpClient(),
        _tokenStore = tokenStore ?? const AuthTokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) {
      throw const UnauthorizedException();
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<MemberAiQueryResponseModel> sendQuery(String query) async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/member/ai-assistant/query');

    try {
      final response = await _client
          .post(
            uri,
            headers: await _headers(),
            body: jsonEncode({'query': query}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 401) throw const UnauthorizedException();
      if (response.statusCode == 403) throw const ForbiddenException();
      if (response.statusCode >= 400) {
        throw ServerException(message: 'HTTP ${response.statusCode}: ${response.body}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return MemberAiQueryResponseModel.fromJson(json);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }
}
