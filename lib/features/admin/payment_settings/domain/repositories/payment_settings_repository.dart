// lib/features/admin/payment_settings/domain/repositories/payment_settings_repository.dart

import '../entities/payment_method_entity.dart';

abstract class PaymentSettingsRepository {
  Future<List<PaymentMethodEntity>> getPaymentMethods();

  Future<void> saveConfig({
    required String methodName,
    required bool   enabled,
    required Map<String, dynamic> configValues,
  });

  Future<Map<String, dynamic>> testConnection(String methodName);
}
