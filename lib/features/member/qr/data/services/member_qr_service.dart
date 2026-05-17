import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/authed_http_client.dart';
import '../../../../auth/data/services/auth_token_store.dart';
import '../models/member_qr_model.dart';

/// Remote service for member QR backend APIs.
///
/// This is the only class in this feature that talks directly to HTTP.
///
/// Backend endpoints used:
/// - GET  /api/member/qr
/// - POST /api/member/qr/generate
///
/// Full chain:
/// MemberQrBloc
/// -> GetMemberQrUseCase / RefreshMemberQrUseCase
/// -> MemberQrRepository
/// -> MemberQrRepositoryImpl
/// -> MemberQrService
/// -> Backend
class MemberQrService {
  final http.Client _client;
  final AuthTokenStore _tokenStore;

  MemberQrService({
    http.Client? client,
    AuthTokenStore tokenStore = const AuthTokenStore(),
  })  : _client = client ?? AuthedHttpClient(),
        _tokenStore = tokenStore;

  /// Builds authorization headers for secured member endpoints.
  ///
  /// Example:
  /// Authorization: Bearer eyJhbGciOi...
  Future<Map<String, String>> _authHeaders() async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    return {
      'Authorization': token.toLowerCase().startsWith('bearer ')
          ? token
          : 'Bearer $token',
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  /// Decodes response body using UTF-8.
  ///
  /// Important because packageName can be Arabic:
  /// الباقة الذهبية
  String _decodeBody(http.Response response) {
    return utf8.decode(response.bodyBytes);
  }

  /// Calls:
  /// GET /api/member/qr
  ///
  /// This loads full QR screen data:
  /// - token
  /// - expiresAt
  /// - membershipStatus
  /// - memberCode
  /// - packageName
  /// - validUntil
  /// - recentVisits
  Future<MemberQrModel> getMemberQr() async {
    final headers = await _authHeaders();

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/member/qr');

    try {
      final response = await _client.get(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('[MemberQr] GET /api/member/qr');
      debugPrint('[MemberQr] Status: ${response.statusCode}');
      debugPrint('[MemberQr] Body: $decodedBody');

      if (response.statusCode == 200) {
        return MemberQrModel.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('[MemberQr] GET error: $e');
      debugPrint('[MemberQr] GET stack: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  /// Calls:
  /// POST /api/member/qr/generate
  ///
  /// This forces the backend to generate a new QR token.
  ///
  /// Backend response here is only:
  /// {
  ///   "token": "uuid-string",
  ///   "expiresAt": "2026-05-15T12:35:00"
  /// }
  ///
  /// But the screen needs full data, so the repository will call
  /// getMemberQr() again after refresh succeeds.
  Future<void> refreshMemberQr() async {
    final headers = await _authHeaders();

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/member/qr/generate');

    try {
      final response = await _client.post(
        uri,
        headers: headers,
      );

      final decodedBody = _decodeBody(response);

      debugPrint('[MemberQr] POST /api/member/qr/generate');
      debugPrint('[MemberQr] Status: ${response.statusCode}');
      debugPrint('[MemberQr] Body: $decodedBody');

      if (response.statusCode == 200) {
        return;
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw ForbiddenException();
      }

      throw ServerException(message: decodedBody);
    } catch (e, stackTrace) {
      debugPrint('[MemberQr] Refresh error: $e');
      debugPrint('[MemberQr] Refresh stack: $stackTrace');

      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }
}