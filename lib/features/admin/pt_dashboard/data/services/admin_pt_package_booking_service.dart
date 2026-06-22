import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:build4allgym/core/network/authed_http_client.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../membership_requests/domain/entities/admin_refund_request_entity.dart';

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
  // amountPaid: omit (or pass null) for full payment; pass a lower amount to
  // record a partial cash payment — the package still activates but its
  // sessions stay out of trainer income until the balance is settled via
  // the Invoices screen's "Record Payment" action.
  Future<Map<String, dynamic>> confirmCash(int bookingId, {double? amountPaid}) async {
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/pt-package-bookings/$bookingId/confirm-cash',
    );
    try {
      final response = await _client.post(
        uri,
        headers: _headers(),
        body: amountPaid != null ? jsonEncode({'amountPaid': amountPaid}) : null,
      );
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

  // GET /api/admin/refund-requests?status=pending&type=PT_PACKAGE
  Future<List<AdminRefundRequestEntity>> getPtPackageRefunds() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/refund-requests')
        .replace(queryParameters: {'status': 'pending', 'type': 'PT_PACKAGE'});
    try {
      final response = await _client.get(uri, headers: _headers());
      final body = _decode(response);
      debugPrint('PT PKG REFUNDS STATUS: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(body) as Map<String, dynamic>;
        final list = decoded['requests'] as List? ?? [];
        return list
            .map((e) => _parseRefund(e as Map<String, dynamic>))
            .toList();
      }
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();
      throw ServerException(message: body);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // POST /api/admin/refund-requests/{refundId}/approve
  Future<void> approvePtPackageRefund(
    int refundId,
    double refundAmount, {
    double? deductionAmount,
    String? adminNote,
  }) async {
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/refund-requests/$refundId/approve');
    final payload = <String, dynamic>{'refundAmount': refundAmount};
    if (deductionAmount != null) payload['deductionAmount'] = deductionAmount;
    if (adminNote != null && adminNote.isNotEmpty) payload['adminNote'] = adminNote;
    try {
      final response = await _client.post(uri,
          headers: _headers(), body: jsonEncode(payload));
      final body = _decode(response);
      if (response.statusCode == 200 || response.statusCode == 201) return;
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();
      throw ServerException(message: body);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  // POST /api/admin/refund-requests/{refundId}/reject
  Future<void> rejectPtPackageRefund(int refundId, String reason) async {
    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/admin/refund-requests/$refundId/reject');
    try {
      final response = await _client.post(uri,
          headers: _headers(), body: jsonEncode({'reason': reason}));
      final body = _decode(response);
      if (response.statusCode == 200 || response.statusCode == 201) return;
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.statusCode == 403) throw ForbiddenException();
      throw ServerException(message: body);
    } catch (e) {
      if (e is UnauthorizedException || e is ForbiddenException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  AdminRefundRequestEntity _parseRefund(Map<String, dynamic> json) {
    return AdminRefundRequestEntity(
      refundId: (json['refundId'] as num).toInt(),
      memberName: json['memberName'] as String? ?? '',
      memberEmail: json['memberEmail'] as String? ?? '',
      planName: json['planName'] as String? ?? '',
      requestedAmount: (json['requestedAmount'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      type: json['type'] as String?,
    );
  }

  // POST /api/admin/pt-package-bookings/{id}/reject-cash
  Future<Map<String, dynamic>> rejectCash(int bookingId, String reason) async {
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/pt-package-bookings/$bookingId/reject-cash',
    );
    try {
      final response = await _client.post(
        uri,
        headers: _headers(),
        body: jsonEncode({'reason': reason}),
      );
      final body = _decode(response);
      debugPrint('ADMIN PT PKG REJECT STATUS: ${response.statusCode}');
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
