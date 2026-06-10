import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';

class AdminPtPackageBookingService {
  final _client = AuthedHttpClient();

  Map<String, String> _headers() => const {'Content-Type': 'application/json'};

  String _decode(http.Response r) => utf8.decode(r.bodyBytes);

  // GET /api/admin/pt-package-bookings/pending
  Future<List<Map<String, dynamic>>> getPendingCash() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/pt-package-bookings/pending');
    try {
      final response = await _client.get(uri, headers: _headers());
      final body = _decode(response);
      debugPrint('ADMIN PT PKG PENDING STATUS: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(body);
        if (decoded is List) return decoded.cast<Map<String, dynamic>>();
        return const [];
      }
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();
      throw ServerException(message: body);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // POST /api/admin/pt-package-bookings/{id}/confirm-cash
  Future<Map<String, dynamic>> confirmCash(int bookingId) async {
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/pt-package-bookings/$bookingId/confirm-cash',
    );
    try {
      final response = await _client.post(uri, headers: _headers());
      final body = _decode(response);
      debugPrint('ADMIN PT PKG CONFIRM STATUS: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(body) as Map<String, dynamic>;
      }
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();
      throw ServerException(message: body);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}
