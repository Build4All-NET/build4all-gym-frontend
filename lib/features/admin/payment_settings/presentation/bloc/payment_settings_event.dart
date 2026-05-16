// lib/features/admin/payment_settings/presentation/bloc/payment_settings_event.dart

import 'package:equatable/equatable.dart';

abstract class PaymentSettingsEvent extends Equatable {
  const PaymentSettingsEvent();
  @override
  List<Object?> get props => [];
}

/// Load payment methods from backend.
class LoadPaymentMethods extends PaymentSettingsEvent {
  const LoadPaymentMethods();
}

/// Save (create/update) config for one method.
class SavePaymentConfig extends PaymentSettingsEvent {
  final String methodName;
  final bool   enabled;
  final Map<String, dynamic> configValues;

  const SavePaymentConfig({
    required this.methodName,
    required this.enabled,
    required this.configValues,
  });

  @override
  List<Object?> get props => [methodName, enabled, configValues];
}

/// Run the gateway self-test for a method.
class TestPaymentConnection extends PaymentSettingsEvent {
  final String methodName;
  const TestPaymentConnection(this.methodName);
  @override
  List<Object?> get props => [methodName];
}
