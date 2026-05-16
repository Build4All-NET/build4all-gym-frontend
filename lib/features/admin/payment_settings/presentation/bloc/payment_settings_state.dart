// lib/features/admin/payment_settings/presentation/bloc/payment_settings_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_method_entity.dart';

enum PaymentSettingsStatus { initial, loading, loaded, saving, error }

class PaymentSettingsState extends Equatable {
  final PaymentSettingsStatus   status;
  final List<PaymentMethodEntity> methods;
  final String?                 errorMessage;

  /// Which method is currently being saved (shows spinner on its tile).
  final String?                 savingMethod;

  /// Result of the last test call: { "success": bool, "message": String }
  final Map<String, dynamic>?   testResult;
  final String?                 testedMethod;

  const PaymentSettingsState({
    this.status       = PaymentSettingsStatus.initial,
    this.methods      = const [],
    this.errorMessage,
    this.savingMethod,
    this.testResult,
    this.testedMethod,
  });

  PaymentSettingsState copyWith({
    PaymentSettingsStatus?    status,
    List<PaymentMethodEntity>? methods,
    String?                   errorMessage,
    String?                   savingMethod,
    Map<String, dynamic>?     testResult,
    String?                   testedMethod,
    bool                      clearError   = false,
    bool                      clearTest    = false,
    bool                      clearSaving  = false,
  }) {
    return PaymentSettingsState(
      status:        status        ?? this.status,
      methods:       methods       ?? this.methods,
      errorMessage:  clearError    ? null : (errorMessage ?? this.errorMessage),
      savingMethod:  clearSaving   ? null : (savingMethod ?? this.savingMethod),
      testResult:    clearTest     ? null : (testResult   ?? this.testResult),
      testedMethod:  clearTest     ? null : (testedMethod ?? this.testedMethod),
    );
  }

  @override
  List<Object?> get props => [status, methods, errorMessage, savingMethod, testResult, testedMethod];
}
