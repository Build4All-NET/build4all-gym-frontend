// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/trainers/data/services/admin_trainers_service.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/admin_trainer_card_model.dart';
import '../models/admin_trainer_detail_model.dart';
import '../models/admin_trainer_list_response_model.dart';
import '../models/create_trainer_request_model.dart';
import '../models/trainer_form_options_model.dart';
import '../models/update_trainer_request_model.dart';

class AdminTrainersService {
  final _client = AuthedHttpClient();
  final AdminTokenStore _tokenStore;

  AdminTrainersService() : _tokenStore = const AdminTokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization':           'Bearer $token',
      'Content-Type':            'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  void _handleStatus(http.Response r) {
    if (r.statusCode == 200 || r.statusCode == 201 || r.statusCode == 204) return;
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: 'HTTP ${r.statusCode}: ${r.body}');
  }

  // ── GET /api/admin/gym-trainers ───────────────────────────────────────────────
  Future<AdminTrainerListResponseModel> getTrainers({
    int?    branchId,
    String? search,
    String? specialtyFilter,
  }) async {
    final headers = await _headers();
    final params  = <String, String>{};
    if (branchId        != null) params['branchId']  = branchId.toString();
    if (search          != null && search.isNotEmpty) params['search'] = search;
    if (specialtyFilter != null && specialtyFilter.isNotEmpty)
      params['specialty'] = specialtyFilter;

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/gym-trainers')
        .replace(queryParameters: params.isEmpty ? null : params);

    try {
      final r = await _client.get(uri, headers: headers);
      print('🔍 getTrainers status: ${r.statusCode} body: ${r.body}'); // ← here

      _handleStatus(r);
      return AdminTrainerListResponseModel.fromJson(jsonDecode(r.body));
    } catch (e) {
      print('❌ getTrainers exception: ${e.runtimeType} — $e'); // ← not e.statusCode

      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── GET /api/admin/trainers/form-options ──────────────────────────────────
  Future<TrainerFormOptionsModel> getFormOptions() async {
    final headers = await _headers();
    final uri     = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/trainers/form-options');
    try {
      final r = await _client.get(uri, headers: headers);
      _handleStatus(r);
      return TrainerFormOptionsModel.fromJson(
          jsonDecode(r.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── POST /api/admin/trainers ──────────────────────────────────────────────
  Future<int> createTrainer(CreateTrainerRequestModel request) async {
    final headers = await _headers();
    final uri     = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/trainers');
    try {
      final r = await _client.post(uri,
          headers: headers, body: jsonEncode(request.toJson()));
      _handleStatus(r);
      final json = jsonDecode(r.body) as Map<String, dynamic>;
      return json['trainerId'] as int;
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PUT /api/admin/trainers/{trainerId} ───────────────────────────────────
  Future<void> updateTrainer(int trainerId, UpdateTrainerRequestModel request) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/trainers/$trainerId');
    try {
      final r = await _client.put(uri,
          headers: headers, body: jsonEncode(request.toJson()));
      _handleStatus(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── PATCH /api/admin/trainers/{trainerId}/block ───────────────────────────
  Future<String> blockTrainer(int trainerId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/trainers/$trainerId/block');
    try {
      final r = await _client.patch(uri, headers: headers);
      _handleStatus(r);
      // BE returns new status as { "status": "BLOCKED" } or "ACTIVE"
      final json = jsonDecode(r.body) as Map<String, dynamic>;
      return json['status'] as String? ?? 'BLOCKED';
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }


// ── GET /api/admin/trainers/{trainerId}/detail ────────────────────────────

  Future<AdminTrainerDetailModel> getTrainerDetail(int trainerId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/trainers/$trainerId/detail');
    try {
      final r = await _client.get(uri, headers: headers);
      _handleStatus(r);
      return AdminTrainerDetailModel.fromJson(
          jsonDecode(r.body) as Map<String, dynamic>);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
// PATCH for: lib/features/admin/trainers/data/services/admin_trainers_service.dart
//
// ADD this method at the bottom of the AdminTrainersService class,
// just before the closing brace.
//
// It calls POST /api/admin/members/{userId}/gym-role
// — the endpoint we already built in AdminMemberRoleController.java.
// ─────────────────────────────────────────────────────────────────────────────

  // ── POST /api/admin/members/{userId}/trainer-config ──────────────────────
  Future<void> configureTrainer(int userId, Map<String, dynamic> body) async {
    final headers = await _headers();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/members/$userId/trainer-config',
    );
    try {
      final r = await _client.post(uri, headers: headers, body: jsonEncode(body));
      _handleStatus(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // ── POST /api/admin/members/{userId}/gym-role ─────────────────────────────
  Future<void> assignGymRole(int userId, String role) async {
    final headers = await _headers();
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/members/$userId/gym-role',
    );
    try {
      final r = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({'role': role}),
      );
      _handleStatus(r);
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}