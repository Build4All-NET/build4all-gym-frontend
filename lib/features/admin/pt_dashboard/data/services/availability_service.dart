
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/exceptions/auth_exception.dart';
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/availability_model.dart';

class AvailabilityHttpService {
  final _client = AuthedHttpClient();
  final _tokenStore = const AdminTokenStore();


  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Never _handleError(http.Response r) {
    if (r.statusCode == 401) throw UnauthorizedException();
    if (r.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: utf8.decode(r.bodyBytes));
  }

  Future<List<AvailabilityModel>> getSlots({
    int? trainerId,
    required int branchId,
  }) async {
    final headers = await _headers();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/availability?branchId=$branchId';
    final uri = Uri.parse(
        trainerId != null ? '$base&trainerId=$trainerId' : base);
    try {
      final r = await _client.get(uri, headers: headers);
      debugPrint('GET AVAILABILITY: ${r.statusCode}');
      if (r.statusCode == 200) {
        final list = jsonDecode(utf8.decode(r.bodyBytes)) as List<dynamic>;
        return list.map((e) => AvailabilityModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  Future<AvailabilityModel> createSlot({
    required int trainerId,
    required int branchId,
    required int weekday,
    required String startTime, // "HH:mm"
    required String endTime,
    bool recurring = true,
  }) async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/trainer/availability');
    try {
      final r = await _client.post(uri, headers: headers, body: jsonEncode({
        'trainerId': trainerId,
        'branchId': branchId,
        'weekday': weekday,
        'startTime': startTime,
        'endTime': endTime,
        'recurring': recurring,
      }));
      debugPrint('CREATE AVAILABILITY: ${r.statusCode}');
      if (r.statusCode == 200 || r.statusCode == 201) {
        return AvailabilityModel.fromJson(
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
      }
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  Future<void> deleteSlot(int availabilityId) async {
    final headers = await _headers();
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/trainer/availability/$availabilityId');
    try {
      final r = await _client.delete(uri, headers: headers);
      if (r.statusCode == 204) return;
      _handleError(r);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}