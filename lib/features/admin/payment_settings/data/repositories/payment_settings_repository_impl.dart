// lib/features/admin/payment_settings/data/repositories/payment_settings_repository_impl.dart

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_settings_repository.dart';
import '../models/payment_method_model.dart';
import '../services/admin_payment_settings_service.dart';

class PaymentSettingsRepositoryImpl implements PaymentSettingsRepository {
  final AdminPaymentSettingsService _service;

  PaymentSettingsRepositoryImpl(this._service);

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    final raw = await _service.getPaymentMethods();
    return raw.map(PaymentMethodModel.fromJson).toList();
  }

  @override
  Future<void> saveConfig({
    required String methodName,
    required bool enabled,
    required Map<String, dynamic> configValues,
  }) {
    return _service.saveConfig(
      methodName: methodName,
      enabled: enabled,
      configValues: configValues,
    );
  }

  @override
  Future<Map<String, dynamic>> testConnection(String methodName) {
    return _service.testConnection(methodName);
  }
}
