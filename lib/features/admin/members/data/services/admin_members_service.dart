// =============================================================================
// FILE: admin_members_service.dart
// PATH: lib/features/admin/members/data/services/admin_members_service.dart
// LAYER: Data Layer → Services
// TASK: GA-268 — added getMemberDetail()
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/member_detail_model.dart';

class AdminMembersService {
  final AdminTokenStore _tokenStore;

  AdminMembersService() : _tokenStore = const AdminTokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization':           'Bearer $token',
      'Content-Type':            'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  void _handleStatus(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 204) return;
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: 'HTTP ${response.statusCode}: ${response.body}');
  }

  Map<String, dynamic> _parseMap(http.Response response) {
    if (response.body.isEmpty) {
      throw ServerException(message: 'Server returned an empty response.');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ServerException(
        message: 'Unexpected response shape: ${decoded.runtimeType}',
      );
    }
    return decoded;
  }

  // ---------------------------------------------------------------------------
  // GET /api/admin/members
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> getMembers({
    required int branchId,
    String status = '',
    String gender = '',
    String search = '',
    String sort   = 'newest',
    int page      = 1,
    int size      = 10,
  }) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/members')
        .replace(queryParameters: {
      'branchId': branchId.toString(),
      'page':     (page - 1).toString(),
      'size':     size.toString(),
      'sort':     sort,
      if (status.isNotEmpty) 'status': status,
      if (gender.isNotEmpty) 'gender': gender,
      if (search.isNotEmpty) 'search': search,
    });
    try {
      final response = await http.get(uri, headers: headers);
      _handleStatus(response);
      return _parseMap(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ---------------------------------------------------------------------------
  // GET /api/admin/members/{userId}   — GA-268
  // ---------------------------------------------------------------------------
  Future<MemberDetailModel> getMemberDetail(int userId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/$userId');
    try {
      final response = await http.get(uri, headers: headers);
      _handleStatus(response);
      return MemberDetailModel.fromJson(_parseMap(response));
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/admin/members/{userId}/block
  // ---------------------------------------------------------------------------
  Future<void> blockMember(int userId, String reason) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/$userId/block');
    try {
      final response = await http.patch(
        uri, headers: headers,
        body: reason.isNotEmpty ? jsonEncode({'reason': reason}) : null,
      );
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/admin/members/{userId}/unblock
  // ---------------------------------------------------------------------------
  Future<void> unblockMember(int userId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/$userId/unblock');
    try {
      final response = await http.patch(uri, headers: headers);
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/admin/members/{userId}
  // ---------------------------------------------------------------------------
  Future<void> deleteMember(int userId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/$userId');
    try {
      final response = await http.delete(uri, headers: headers);
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/admin/members/bulk
  // ---------------------------------------------------------------------------
  Future<void> bulkDeleteMembers(List<int> userIds) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/members/bulk');
    try {
      final response = await http.delete(
          uri, headers: headers, body: jsonEncode(userIds));
      _handleStatus(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}