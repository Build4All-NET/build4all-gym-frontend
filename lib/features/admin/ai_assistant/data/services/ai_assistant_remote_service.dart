// =============================================================================
// FILE: ai_assistant_remote_service.dart
// PATH: lib/features/owner/ai_assistant/data/services/ai_assistant_remote_service.dart
// LAYER: Data Layer → Services (Remote)
// =============================================================================
// Makes all HTTP calls to the AI assistant backend endpoints.
// Follows the exact same pattern as AdminDashboardRemoteDatasourceImpl:
//   - uses http.dart (not Dio — matches your existing codebase)
//   - reads token from AdminTokenStore
//   - sends Authorization + X-Owner-Project-Link-Id headers
//   - throws typed exceptions (UnauthorizedException, ForbiddenException,
//     ServerException, NetworkException)
//
// Endpoints:
//   POST /api/owner/ai-assistant/query       → sendQuery()
//   GET  /api/owner/ai-assistant/suggestions → getSuggestions()
//   GET  /api/owner/ai-assistant/history     → getHistory()
//
// The repository impl calls this service, catches exceptions, and maps
// models to domain entities — this file only handles raw HTTP.
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/ai_query_history_model.dart';
import '../models/ai_query_request_model.dart';
import '../models/ai_query_response_model.dart';

class AiAssistantRemoteService {
  final _client = AuthedHttpClient();
  final AdminTokenStore _tokenStore;

  AiAssistantRemoteService()
      : _tokenStore = const AdminTokenStore();

  // ── Shared: build the headers for every request ───────────────────────────
  // Follows the same header pattern as AdminDashboardRemoteDatasourceImpl.
  // Throws UnauthorizedException immediately if there is no stored token.
  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw const UnauthorizedException();
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  // ── Shared: map HTTP status codes to typed exceptions ────────────────────
  // Called after every response so every method benefits from the same logic.
  void _checkStatus(http.Response response) {
    if (response.statusCode == 200) return; // success — nothing to throw
    if (response.statusCode == 401) throw const UnauthorizedException();
    if (response.statusCode == 403) throw const ForbiddenException();
    throw ServerException(message: response.body);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // sendQuery(requestModel)
  // ─────────────────────────────────────────────────────────────────────────
  // POST /api/owner/ai-assistant/query
  //
  // Sends the owner's query + conversation history to the backend.
  // Returns a parsed AiQueryResponseModel on success.
  //
  // The JSON body shape matches AiQueryRequestModel.toJson():
  //   { "query": "...", "conversationHistory": [...] }
  // ─────────────────────────────────────────────────────────────────────────
  Future<AiQueryResponseModel> sendQuery(AiQueryRequestModel requestModel) async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/owner/ai-assistant/query');

    try {
      final response = await _client.post(
        uri,
        headers: await _headers(),
        body: jsonEncode(requestModel.toJson()),
      );

      _checkStatus(response);

      // Parse the response body and return the model
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AiQueryResponseModel.fromJson(json);

    } catch (e) {
      // Re-throw typed exceptions unchanged so the repository can handle them
      if (e is UnauthorizedException ||
          e is ForbiddenException    ||
          e is ServerException) {
        rethrow;
      }
      // Any other exception (socket, timeout, etc.) → NetworkException
      throw const NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // getSuggestions()
  // ─────────────────────────────────────────────────────────────────────────
  // GET /api/owner/ai-assistant/suggestions
  //
  // Returns the 5 hardcoded suggested questions from the backend.
  // Response shape: [ { "question": "..." }, ... ]
  //
  // We return List<String> (just the question strings) since that is all
  // the repository needs — the repo wraps them in SuggestedQuestionEntity.
  // ─────────────────────────────────────────────────────────────────────────
  Future<List<String>> getSuggestions() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/owner/ai-assistant/suggestions');

    try {
      final response = await _client.get(uri, headers: await _headers());
      _checkStatus(response);

      // Response: [ { "question": "What's my revenue today?" }, ... ]
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((item) => (item as Map<String, dynamic>)['question'] as String)
          .toList();

    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException    ||
          e is ServerException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // getHistory()
  // ─────────────────────────────────────────────────────────────────────────
  // GET /api/owner/ai-assistant/history
  //
  // Returns the last 10 queries the current owner made.
  // Response shape: [ { "id": 42, "queryText": "...", "responseAnswer": "...",
  //                     "createdAt": "2025-05-07T10:23:45" }, ... ]
  // ─────────────────────────────────────────────────────────────────────────
  Future<List<AiQueryHistoryModel>> getHistory() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/owner/ai-assistant/history');

    try {
      final response = await _client.get(uri, headers: await _headers());
      _checkStatus(response);

      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((item) => AiQueryHistoryModel.fromJson(item as Map<String, dynamic>))
          .toList();

    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException    ||
          e is ServerException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }
}