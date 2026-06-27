// lib/core/currency/currency_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';

import 'currency_info.dart';

class CurrencyService {
  final Dio dio;

  CurrencyService(this.dio);

  /// GET {apiBaseUrl}/api/currencies/{currencyId} on the build4all backend.
  Future<CurrencyInfo> fetchById({
    required String apiBaseUrl,
    required String currencyId,
  }) async {
    final url = '$apiBaseUrl/api/currencies/$currencyId';
    final resp = await dio.get(url);

    final data = resp.data;
    if (data is Map<String, dynamic>) return CurrencyInfo.fromJson(data);
    if (data is Map) return CurrencyInfo.fromJson(Map<String, dynamic>.from(data));
    if (data is String) {
      return CurrencyInfo.fromJson(jsonDecode(data) as Map<String, dynamic>);
    }

    throw Exception('Unexpected currency response type: ${data.runtimeType}');
  }
}
