// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/branches/data/services/admin_branches_service.dart
//
// PURPOSE:
//   Makes ALL HTTP calls for the admin branches feature.
//   Pattern: identical to AdminClassesService — uses http package directly
//   with AdminTokenStore for JWT and Env.apiProjectBaseUrl for the base URL.
//
// BASE PATH: /api/admin/branches
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../model/admin_branch_list_response_model.dart';
import '../model/branch_card_model.dart';
import '../model/branch_detail_model.dart';
import '../model/create_branch_request_model.dart';

class AdminBranchesService {
  final AdminTokenStore _tokenStore;

  // const constructor so it can be created inline anywhere
  AdminBranchesService() : _tokenStore = const AdminTokenStore();

  // ── Shared: build auth headers ──────────────────────────────────────────────
  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization':           'Bearer $token',
      'Content-Type':            'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  // ── Shared: status code guard ───────────────────────────────────────────────
  void _handleStatus(http.Response response) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) return;
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    throw ServerException(
        message: 'HTTP ${response.statusCode}: ${response.body}');
  }

  // ── GET /api/admin/branches ─────────────────────────────────────────────────
  // Returns aggregate stats + branch list.
  // status: "ACTIVE" | "INACTIVE" | null (all)
  // search: partial match on name/city | null
  Future<AdminBranchListResponseModel> getBranches({
    String? status,
    String? search,
  }) async {
    final headers = await _headers();

    final params = <String, String>{};
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/branches')
        .replace(queryParameters: params.isEmpty ? null : params);

    try {
      final response = await http.get(uri, headers: headers);
      _handleStatus(response);
      return AdminBranchListResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── GET /api/admin/branches/{branchId} ─────────────────────────────────────
  // Returns the full detail for a single branch (Branch Detail screen).
  Future<BranchDetailModel> getBranchDetail(String branchId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/branches/$branchId');

    try {
      final response = await http.get(uri, headers: headers);
      _handleStatus(response);
      return BranchDetailModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── POST /api/admin/branches ────────────────────────────────────────────────
  // Creates a new branch. Returns the created BranchCardModel from the response body.
  Future<BranchCardModel> createBranch(
      CreateBranchRequestModel request) async {
    final headers = await _headers();
    final uri =
    Uri.parse('${Env.apiProjectBaseUrl}/api/admin/branches');

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );
      _handleStatus(response);
      // BE returns 201 + the created BranchCardDto as JSON
      return BranchCardModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── GET /api/admin/branches/options ────────────────────────────────────────
  // Returns slim list of active branches for form dropdowns
  // (used by Classes, Plans, Staff filters — active branches only).
  // Returns [ { "id": "uuid", "name": "Mumbai Central" }, … ]
  Future<List<Map<String, dynamic>>> getBranchOptions() async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/branches/options');

    try {
      final response = await http.get(uri, headers: headers);
      _handleStatus(response);
      final rawList = jsonDecode(response.body) as List<dynamic>;
      return rawList
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}