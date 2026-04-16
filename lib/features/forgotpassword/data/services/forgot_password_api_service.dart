import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/exceptions/app_exception.dart';
import 'package:build4allgym/core/exceptions/network_exception.dart';
import 'package:http/http.dart' as http;

import '../models/forgot_password_models.dart';


// Three methods = three steps = three backend endpoints.
class ForgotPasswordApiService {
  final http.Client _client;

  ForgotPasswordApiService({http.Client? client})
      : _client = client ?? http.Client();

  // Gets the base URL from Env (configured via --dart-define=API_BASE_URL=...)
  String get _base => Env.apiBaseUrl;

  // Builds the full URL from a path
  // Example: _uri('/auth/forgot-password') → http://192.168.1.12:8867/auth/forgot-password
  Uri _uri(String path) => Uri.parse('$_base$path');

  // ── STEP 1 ────────────────────────────────────────────────────────────────
  // Called when user taps "Send OTP" on Screen 1
  // Sends: POST /auth/forgot-password  { "identifier": "john@gmail.com" }
  // Returns: ForgotPasswordData (maskedContact + deliveryMethod)
  Future<ForgotPasswordData> initiateForgotPassword(String identifier) async {
    final uri = _uri('/api/auth/send-verification');

    try {
      final resp = await _safePost(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier}),
      );

      final decoded = _safeJson(resp.body);

      // If backend returned an error (400, 500...) → throw AppException
      // GlobalExceptionHandler format: { "status": 400, "message": "..." }
      if (resp.statusCode != 200) {
        final msg = decoded['message'] ?? 'Failed to send OTP';
        throw AppException(msg.toString(), code: 'FORGOT_ERROR');
      }

      // Success format: { "success": true, "data": { "maskedContact": "...", "deliveryMethod": "..." } }
      final apiResp = ApiResponse.fromJson(decoded);
      return ForgotPasswordData.fromJson(apiResp.data!);

    } on AppException {
      rethrow; // already our exception, just pass it up
    } catch (e) {
      throw AppException('Failed to send OTP', original: e);
    }
  }

  // ── STEP 2 ────────────────────────────────────────────────────────────────
  // Called when user taps "Verify" on Screen 2
  // Sends: POST /auth/verify-otp  { "identifier": "...", "otpCode": "292738" }
  // Returns: VerifyOtpData (the UUID resetToken)
  Future<VerifyOtpData> verifyOtp(String identifier, String otpCode) async {
    final uri = _uri('/auth/users/reset-password');

    try {
      final resp = await _safePost(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier, 'otpCode': otpCode}),
      );

      final decoded = _safeJson(resp.body);

      if (resp.statusCode != 200) {
        final msg = decoded['message'] ?? 'Invalid or expired OTP';
        throw AppException(msg.toString(), code: 'OTP_ERROR');
      }

      final apiResp = ApiResponse.fromJson(decoded);
      return VerifyOtpData.fromJson(apiResp.data!);

    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to verify OTP', original: e);
    }
  }

  // ── STEP 3 ────────────────────────────────────────────────────────────────
  // Called when user taps "Save Password" on Screen 3
  // Sends: POST /auth/reset-password  { "resetToken": "...", "newPassword": "..." }
  // Returns: just the success message string
  Future<String> resetPassword(String resetToken, String newPassword) async {
    final uri = _uri('/auth/reset-password');

    try {
      final resp = await _safePost(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'resetToken': resetToken,
          'newPassword': newPassword,
        }),
      );

      final decoded = _safeJson(resp.body);

      if (resp.statusCode != 200) {
        final msg = decoded['message'] ?? 'Failed to reset password';
        throw AppException(msg.toString(), code: 'RESET_ERROR');
      }

      return decoded['message']?.toString() ?? 'Password reset successfully';

    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to reset password', original: e);
    }
  }

  // ── PRIVATE HELPERS (copied from auth_api_service.dart) ─────────

  // Safely parses JSON — if body is empty or broken, returns empty map
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

  // Sends a POST request safely.
  // If no internet → throws NetworkException
  // If timeout → throws NetworkException
  // SAME pattern as _safePost in auth_api_service.dart
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
      // No internet connection
      throw NetworkException('No internet connection', original: e);
    } on TimeoutException catch (e) {
      // Request took too long
      throw NetworkException('Request timed out', original: e);
    } on http.ClientException catch (e) {
      // HTTP-level error
      throw NetworkException('Network error', original: e);
    }
  }
}