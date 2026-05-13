import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/exceptions/auth_exception.dart';
import 'package:build4allgym/core/exceptions/forbidden_exception.dart';
import 'package:build4allgym/core/exceptions/network_exception.dart';
import 'package:build4allgym/core/exceptions/server_exception.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import 'package:flutter/foundation.dart';
import '../models/body_metric_model.dart';
import '../models/member_home_model.dart';

// Why this datasource exists:
// This file is responsible for communicating with the backend member home APIs.
// It keeps HTTP requests, token handling, JSON decoding, and API error handling
// inside the data layer instead of spreading them across the UI, BLoC, or domain.
//
// Example flow:
// 1. BLoC asks repositories for member home data.
// 2. Repository calls MemberHomeRemoteDatasource.getMemberHome().
// 3. Datasource calls GET /api/member/home.
// 4. Backend returns JSON.
// 5. Datasource parses JSON into MemberHomeModel.
// 6. Repository/domain can use the parsed model cleanly.
//
// Example backend response for GET /api/member/home:
// {
//   "membership": {
//     "planName": "Active Gold",
//     "planType": "GOLD",
//     "status": "active",
//     "startDate": "2024-06-15",
//     "expirationDate": "2024-07-15",
//     "remainingDays": 23,
//     "canRenew": true,
//     "canFreeze": false
//   },
//   "stats": {
//     "sessionsCount": 12,
//     "kgLost": 8.5,
//     "workoutsCount": 24,
//     "referralCode": "FIT2024"
//   },
//   "schedule": {
//     "items": []
//   },
//   "quote": {
//     "text": "Success is the sum of small efforts repeated daily",
//     "languageCode": "en"
//   }
// }

class MemberHomeRemoteDatasource {
  // HTTP client used to send GET and POST requests.
  final http.Client _client;

  // Token store used to read the saved auth token from secure storage.
  // We use this instead of hardcoding the storage key.
  final AuthTokenStore _tokenStore;

  MemberHomeRemoteDatasource({
    http.Client? client,
    required AuthTokenStore tokenStore,
  })  : _client = client ?? AuthedHttpClient(),
        _tokenStore = tokenStore;

  // Base URL is read from environment config.
  // This avoids hardcoding backend URLs inside the datasource.
  String get _base => Env.apiProjectBaseUrl;

  // Builds a full URI from a relative backend path.
  Uri _uri(String path) => Uri.parse('$_base$path');

  // Calls GET /api/member/home.
  // This endpoint returns the full aggregated member home response.
  Future<MemberHomeModel> getMemberHome() async {
    final auth = await _authHeader();

    final response = await _safeGet(
      _uri('/api/member/home'),
      headers: {
        'Authorization': auth,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
// DEBUG: print the real backend response.
// This tells us if the backend returns 200, 401, 403, 500, or bad data.
    debugPrint('[MemberHome] GET /api/member/home');
    debugPrint('[MemberHome] Status code: ${response.statusCode}');
    debugPrint('[MemberHome] Body: ${response.body}');
    final decoded = _safeJson(response.body);

    if (response.statusCode >= 400) {
      _throwHttpError(
        response,
        decoded,
        fallback: 'Failed to load member home',
      );
    }

    return MemberHomeModel.fromJson(decoded);
  }

  // Calls POST /api/member/home/weight.
  //
  // Example request body:
  // {
  //   "weight": 75.5
  // }
  //
  // Example backend response:
  // {
  //   "weight": 75.5,
  //   "recordedAt": "2024-07-15T10:30:00Z"
  // }
  Future<BodyMetricModel> logWeight({required double weight}) async {
    final auth = await _authHeader();

    final response = await _safePost(
      _uri('/api/member/home/weight'),
      headers: {
        'Authorization': auth,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'weight': weight}),
    );

    final decoded = _safeJson(response.body);

    if (response.statusCode >= 400) {
      _throwHttpError(
        response,
        decoded,
        fallback: 'Failed to log weight',
      );
    }

    return BodyMetricModel.fromJson(decoded);
  }

  // Reads the saved access token and formats it for the Authorization header.
  //
  // Why:
  // Every member home API request requires:
  // Authorization: Bearer <token>
  //
  // We do not hardcode the secure storage key here.
  // AuthTokenStore already knows how and where the token is stored.
  Future<String> _authHeader() async {
    final token = (await _tokenStore.getToken())?.trim() ?? '';

    if (token.isEmpty) {
      throw AuthException('Missing token', code: 'UNAUTHORIZED');
    }

    return token.toLowerCase().startsWith('bearer ')
        ? token
        : 'Bearer $token';
  }

  // Sends a safe GET request.
  // Converts timeout, no internet, and client errors into NetworkException.
  Future<http.Response> _safeGet(
      Uri uri, {
        Map<String, String>? headers,
      }) async {
    try {
      return await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
    } on SocketException catch (e) {
      throw NetworkException('No internet connection', original: e);
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out', original: e);
    } on http.ClientException catch (e) {
      throw NetworkException('Network error', original: e);
    }
  }

  // Sends a safe POST request.
  // Used here for logging weight.
  Future<http.Response> _safePost(
      Uri uri, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    try {
      return await _client
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
    } on SocketException catch (e) {
      throw NetworkException('No internet connection', original: e);
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out', original: e);
    } on http.ClientException catch (e) {
      throw NetworkException('Network error', original: e);
    }
  }

  // Safely decodes response body into a JSON map.
  //
  // Why:
  // Backend responses can sometimes be empty or invalid.
  // This prevents jsonDecode from crashing the app directly.
  Map<String, dynamic> _safeJson(String body) {
    if (body.isEmpty) return {};

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {};
    } catch (_) {
      return {};
    }
  }

  // Extracts the backend error message from common response fields.
  //
  // Example backend error:
  // {
  //   "message": "Membership not found"
  // }
  //
  // If no message exists, the fallback message is used.
  String _messageFromJson(
      Map<String, dynamic> json, {
        required String fallback,
      }) {
    for (final key in ['message', 'error', 'detail', 'title']) {
      final value = json[key];

      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return fallback;
  }

  // Maps HTTP error responses into typed app exceptions.
  //
  // Required behavior:
  // - 401 -> AuthException because the session is missing or expired
  // - 403 -> ForbiddenException because the user has no permission
  // - 4xx/5xx -> ServerException with backend message
  Never _throwHttpError(
      http.Response response,
      Map<String, dynamic> decoded, {
        required String fallback,
      }) {
    final message = _messageFromJson(decoded, fallback: fallback);

    if (response.statusCode == 401) {
      throw AuthException(
        message,
        code: 'UNAUTHORIZED',
        original: response,
      );
    }

    if (response.statusCode == 403) {
      throw ForbiddenException(
        message,
        original: response,
      );
    }

    throw ServerException(
      message,
      original: response,
    );
  }
}