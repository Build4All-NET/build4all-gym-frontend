// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/data/services/forgot_password_api_service.dart
//
// PURPOSE:
//   Raw HTTP client for the three forgot-password backend endpoints.
//   Handles serialization, error detection, and low-level exception wrapping.
//   Everything above this layer (repository, use cases, BLoC) never touches
//   http.Response or JSON directly.
//
// THREE STEPS:
//   Step 1 → sendResetCode()    POST /api/users/reset-password
//   Step 2 → verifyResetCode()  POST /api/users/verify-reset-code
//   Step 3 → updatePassword()   POST /api/users/update-password
//
// RELATIONSHIPS:
//   ◀ Called by:  ForgotPasswordRepositoryImpl
//   ▶ Uses:       http.Client, Env.apiBaseUrl, ForgotMessageResponse
//   ▶ Throws:     NetworkException (transport), AuthException (HTTP 4xx/5xx)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:http/http.dart' as http;

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/exceptions/app_exception.dart';
import 'package:build4allgym/core/exceptions/network_exception.dart';

import '../models/forgot_password_models.dart';

class ForgotPasswordApiService {
  /// Injected HTTP client — allows swapping a mock in tests.
  final http.Client _client;

  ForgotPasswordApiService({http.Client? client})
      : _client = client ?? http.Client();

  /// Base API URL from compile-time config (e.g. "http://192.168.1.4:8867").
  String get _base => Env.apiBaseUrl;

  // ── URI BUILDER ──────────────────────────────────────────────────────────

  /// Builds a full URI from [path] and optional [query] parameters.
  /// Example: _uri('/api/users/reset-password', query: {'ownerProjectLinkId': '1'})
  ///          → http://192.168.1.4:8867/api/users/reset-password?ownerProjectLinkId=1
  Uri _uri(String path, {Map<String, String>? query}) {
    final base = Uri.parse('$_base$path');
    if (query == null || query.isEmpty) return base;
    // replace() preserves scheme/host/path and appends query string
    return base.replace(queryParameters: query);
  }

  // ── STEP 1 ────────────────────────────────────────────────────────────────

  /// Sends an OTP reset code to the user's email.
  /// Called by [ForgotPasswordRepositoryImpl.sendResetCode].
  ///
  /// POST /api/users/reset-password?ownerProjectLinkId=X
  /// Body: { "email": "..." }
  Future<ForgotMessageResponse> sendResetCode({
    required String email,
    required int ownerProjectLinkId,
  }) async {
    final uri = _uri(
      '/api/users/reset-password',
      query: {'ownerProjectLinkId': ownerProjectLinkId.toString()},
    );

    debugPrint('🔑 SEND RESET CODE → $uri');

    final resp = await _safePost(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final decoded = _safeJson(resp.body);

    // Any 4xx/5xx → parse the body for a message and throw
    if (resp.statusCode >= 400) {
      _throwFromHttp(resp, decoded, fallback: 'Failed to send reset code');
    }

    return ForgotMessageResponse.fromJson(decoded);
  }

  // ── STEP 2 ────────────────────────────────────────────────────────────────

  /// Verifies the OTP code the user received.
  /// Called by [ForgotPasswordRepositoryImpl.verifyResetCode].
  ///
  /// POST /api/users/verify-reset-code?ownerProjectLinkId=X
  /// Body: { "email": "...", "code": "..." }
  Future<ForgotMessageResponse> verifyResetCode({
    required String email,
    required String code,
    required int ownerProjectLinkId,
  }) async {
    final uri = _uri(
      '/api/users/verify-reset-code',
      query: {'ownerProjectLinkId': ownerProjectLinkId.toString()},
    );

    debugPrint('✅ VERIFY RESET CODE → $uri');

    final resp = await _safePost(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    final decoded = _safeJson(resp.body);

    if (resp.statusCode >= 400) {
      _throwFromHttp(resp, decoded, fallback: 'Invalid reset code');
    }

    return ForgotMessageResponse.fromJson(decoded);
  }

  // ── STEP 3 ────────────────────────────────────────────────────────────────

  /// Updates the user's password after OTP verification.
  /// Called by [ForgotPasswordRepositoryImpl.updatePassword].
  ///
  /// POST /api/users/update-password?ownerProjectLinkId=X
  /// Body: { "email": "...", "code": "...", "newPassword": "..." }
  Future<ForgotMessageResponse> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) async {
    final uri = _uri(
      '/api/users/update-password',
      query: {'ownerProjectLinkId': ownerProjectLinkId.toString()},
    );

    debugPrint('🔁 UPDATE PASSWORD → $uri');

    final resp = await _safePost(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'newPassword': newPassword,
      }),
    );

    final decoded = _safeJson(resp.body);

    if (resp.statusCode >= 400) {
      _throwFromHttp(resp, decoded, fallback: 'Failed to update password');
    }

    return ForgotMessageResponse.fromJson(decoded);
  }

  // ── PRIVATE HELPERS ───────────────────────────────────────────────────────

  /// Wraps [http.Client.post] with a 30-second timeout and converts
  /// transport-level errors into [NetworkException].
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
      // Device is offline or server is unreachable
      throw NetworkException('No internet connection', original: e);
    } on TimeoutException catch (e) {
      // Request took longer than 30 seconds
      throw NetworkException('Request timed out', original: e);
    } on http.ClientException catch (e) {
      // Other HTTP client errors (e.g. TLS failure)
      throw NetworkException('Network error', original: e);
    }
  }

  /// Safely decodes a JSON response body.
  /// Returns an empty map if the body is blank or malformed — prevents crashes
  /// on endpoints that return a plain 200 with no body.
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

  /// Extracts the most relevant user-readable message from a decoded JSON body.
  /// Returns null if neither 'message' nor 'error' keys are present.
  String? _extractMessage(Map<String, dynamic> json) {
    final m = json['message'];
    final e = json['error'];
    if (m is String && m.trim().isNotEmpty) return m;
    if (e is String && e.trim().isNotEmpty) return e;
    return null;
  }

  /// Throws an [AuthException] with the best available message for a failed
  /// HTTP response. Tries the body message first, then falls back to a
  /// status-code-based string, and finally the [fallback] provided by the caller.
  Never _throwFromHttp(
      http.Response resp,
      Map<String, dynamic> decoded, {
        required String fallback,
      }) {
    final msg = _extractMessage(decoded);
    final status = resp.statusCode;

    // Determine the final message: body > status fallback > caller fallback
    final finalMsg = msg ?? _statusMessage(status, fallback);

    throw AuthException(finalMsg, original: resp);
  }

  /// Returns a generic message for known HTTP status codes.
  String _statusMessage(int status, String fallback) {
    switch (status) {
      case 400:
        return 'Invalid request.';
      case 401:
        return 'Unauthorized.';
      case 403:
        return 'No permission.';
      case 404:
        return 'User not found.';
      case 409:
        return 'Conflict.';
      case 422:
        return 'Invalid fields.';
      case 500:
        return 'Server error.';
      default:
        return fallback;
    }
  }
}

/// Thrown when an HTTP response has a 4xx/5xx status code.
/// Treated as an [AppException] with the server's error message.
class AuthException extends AppException {
  AuthException(super.message, {super.original}) : super(code: 'AUTH_ERROR');
}