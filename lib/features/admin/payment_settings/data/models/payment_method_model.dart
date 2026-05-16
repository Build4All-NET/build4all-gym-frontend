// lib/features/admin/payment_settings/data/models/payment_method_model.dart

import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.methodName,
    required super.displayName,
    required super.platformEnabled,
    required super.projectEnabled,
    required super.configured,
    required super.configSchema,
    required super.configValues,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      methodName:      json['methodName']      as String? ?? '',
      displayName:     json['displayName']     as String? ?? '',
      platformEnabled: json['platformEnabled'] as bool?   ?? false,
      projectEnabled:  json['projectEnabled']  as bool?   ?? false,
      configured:      json['configured']      as bool?   ?? false,
      configSchema:    Map<String, dynamic>.from(json['configSchema'] as Map? ?? {}),
      configValues:    Map<String, dynamic>.from(json['configValues'] as Map? ?? {}),
    );
  }
}
