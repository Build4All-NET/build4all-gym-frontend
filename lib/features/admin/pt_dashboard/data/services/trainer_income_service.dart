// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/services/trainer_income_service.dart
// LAYER: Data — HTTP calls only, no domain logic
//
// Endpoint:
//   GET /api/trainer/income?branchId=&from=&to=[&trainerId=]
// Auth: JWT from FlutterSecureStorage via AuthedHttpClient.
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/exceptions/server_exception.dart' hide ServerException;
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/exceptions/forbidden_exception.dart' hide ForbiddenException;
import '../../../../../core/exceptions/network_exception.dart' hide NetworkException;
import '../models/trainer_income_model.dart';

class TrainerIncomeService {
  final _client = AuthedHttpClient();
  static final _dateFmt = DateFormat('yyyy-MM-dd');

  Map<String, String> _authHeaders() => const {
        'Content-Type': 'application/json',
      };

  String _decodeBody(http.Response response) => utf8.decode(response.bodyBytes);

  Never _handleError(http.Response response) {
    final body = _decodeBody(response);
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    throw ServerException(message: body);
  }

  Future<TrainerIncomeSummaryModel> getIncome({
    required int branchId,
    int? trainerId,
    required DateTime from,
    required DateTime to,
  }) async {
    final headers = _authHeaders();
    final base = '${Env.apiProjectBaseUrl}/api/trainer/income'
        '?branchId=$branchId&from=${_dateFmt.format(from)}&to=${_dateFmt.format(to)}';
    final uri = Uri.parse(trainerId != null ? '$base&trainerId=$trainerId' : base);

    try {
      final response = await _client.get(uri, headers: headers);
      debugPrint('GET INCOME STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(_decodeBody(response)) as Map<String, dynamic>;
        return TrainerIncomeSummaryModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      _handleError(response);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}
