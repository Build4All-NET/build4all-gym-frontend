import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/authed_http_client.dart';
import '../../../../auth/data/services/auth_token_store.dart';
import '../models/member_membership_model.dart';

/*
 * Handles the HTTP request for the logged-in member memberships.
 *
 * Endpoint:
 * GET /api/member/memberships
 *
 * Important:
 * - The gym backend URL comes from Env.apiProjectBaseUrl.
 * - userId is not sent from Flutter.
 * - tenantId is not sent from Flutter.
 * - The backend extracts both values from the JWT.
 */
class MemberMembershipService {
  final http.Client _client;
  final AuthTokenStore _tokenStore;

  MemberMembershipService({
    http.Client? client,
    AuthTokenStore? tokenStore,
  })  : _client = client ?? AuthedHttpClient(),
        _tokenStore = tokenStore ?? const AuthTokenStore();

  /*
   * Loads all memberships that belong to the logged-in member.
   *
   * When status is provided, the request becomes:
   *
   * GET /api/member/memberships?status=ACTIVE
   *
   * When status is null or empty:
   *
   * GET /api/member/memberships
   */
  Future<List<MemberMembershipModel>> getMemberships({
    String? status,
  }) async {
    final String authorization = await _authHeader();

    final Map<String, String> queryParameters = {};

    if (status != null && status.trim().isNotEmpty) {
      queryParameters['status'] = status.trim();
    }

    final Uri uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/memberships',
    ).replace(
      queryParameters:
      queryParameters.isEmpty ? null : queryParameters,
    );

    try {
      final http.Response response = await _client.get(
        uri,
        headers: {
          'Authorization': authorization,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      debugPrint(
        '[MemberMembership] GET ${uri.path}',
      );
      debugPrint(
        '[MemberMembership] Status: ${response.statusCode}',
      );
      debugPrint(
        '[MemberMembership] Body: $responseBody',
      );

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(responseBody);

        if (decodedResponse is! List) {
          throw const ServerException(
            message: 'Invalid memberships response format.',
          );
        }

        return decodedResponse.map((dynamic item) {
          if (item is! Map) {
            throw const ServerException(
              message: 'Invalid membership item format.',
            );
          }

          return MemberMembershipModel.fromJson(
            Map<String, dynamic>.from(item),
          );
        }).toList();
      }

      if (response.statusCode == 401) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 403) {
        throw const ForbiddenException();
      }

      throw ServerException(
        message:
        'Failed to load memberships. HTTP ${response.statusCode}: $responseBody',
      );
    } on UnauthorizedException {
      rethrow;
    } on ForbiddenException {
      rethrow;
    } on ServerException {
      rethrow;
    } on FormatException catch (error) {
      throw ServerException(
        message: 'Invalid memberships data: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[MemberMembership] Request error: $error',
      );
      debugPrint(
        '[MemberMembership] Stack trace: $stackTrace',
      );

      throw const NetworkException();
    }
  }

  /*
   * Reads the saved JWT using the existing AuthTokenStore.
   *
   * No userId or tenantId is read or sent from Flutter.
   */
  Future<String> _authHeader() async {
    final String token =
        (await _tokenStore.getToken())?.trim() ?? '';

    if (token.isEmpty) {
      throw const UnauthorizedException();
    }

    return token.toLowerCase().startsWith('bearer ')
        ? token
        : 'Bearer $token';
  }
}