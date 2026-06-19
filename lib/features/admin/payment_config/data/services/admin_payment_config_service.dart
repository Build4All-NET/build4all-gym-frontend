import 'package:dio/dio.dart';
import '../../../../../core/network/globals.dart';
import '../models/payment_method_config_model.dart';

class AdminPaymentConfigService {
  Dio get _dio => appDio ?? Dio(BaseOptions(baseUrl: appServerRoot));

  String _url(String path) => '$appServerRoot$path';

  Future<List<PaymentMethodConfigModel>> getPaymentMethods() async {
    final response = await _dio.get(_url('/api/admin/payment-methods'));
    final data = response.data as List;
    return data
        .map((e) => PaymentMethodConfigModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PaymentMethodConfigModel> saveConfig(
    String methodName,
    bool enabled, {
    String? configJson,
  }) async {
    final response = await _dio.put(
      _url('/api/admin/payment-methods/$methodName'),
      data: {'enabled': enabled, 'configJson': configJson},
    );
    return PaymentMethodConfigModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<({bool ok, String? error})> testConnection(String methodName) async {
    final response = await _dio.post(
      _url('/api/admin/payment-methods/$methodName/test'),
    );
    final data = response.data as Map<String, dynamic>;
    return (
      ok: data['ok'] as bool,
      error: data['error'] as String?,
    );
  }
}
