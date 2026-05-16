// lib/features/admin/payment_settings/presentation/bloc/payment_settings_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/payment_settings_repository.dart';
import 'payment_settings_event.dart';
import 'payment_settings_state.dart';

class PaymentSettingsBloc
    extends Bloc<PaymentSettingsEvent, PaymentSettingsState> {
  final PaymentSettingsRepository _repo;

  PaymentSettingsBloc(this._repo) : super(const PaymentSettingsState()) {
    on<LoadPaymentMethods>(_onLoad);
    on<SavePaymentConfig>(_onSave);
    on<TestPaymentConnection>(_onTest);
  }

  Future<void> _onLoad(
    LoadPaymentMethods event,
    Emitter<PaymentSettingsState> emit,
  ) async {
    emit(state.copyWith(status: PaymentSettingsStatus.loading, clearError: true));
    try {
      final methods = await _repo.getPaymentMethods();
      emit(state.copyWith(status: PaymentSettingsStatus.loaded, methods: methods));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentSettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSave(
    SavePaymentConfig event,
    Emitter<PaymentSettingsState> emit,
  ) async {
    emit(state.copyWith(
      status: PaymentSettingsStatus.saving,
      savingMethod: event.methodName,
      clearError: true,
    ));
    try {
      await _repo.saveConfig(
        methodName:   event.methodName,
        enabled:      event.enabled,
        configValues: event.configValues,
      );
      // Reload the list so the tile reflects the new state
      final methods = await _repo.getPaymentMethods();
      emit(state.copyWith(
        status:       PaymentSettingsStatus.loaded,
        methods:      methods,
        clearSaving:  true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status:       PaymentSettingsStatus.error,
        errorMessage: e.toString(),
        clearSaving:  true,
      ));
    }
  }

  Future<void> _onTest(
    TestPaymentConnection event,
    Emitter<PaymentSettingsState> emit,
  ) async {
    emit(state.copyWith(savingMethod: event.methodName, clearTest: true));
    try {
      final result = await _repo.testConnection(event.methodName);
      emit(state.copyWith(
        testResult:   result,
        testedMethod: event.methodName,
        clearSaving:  true,
      ));
    } catch (e) {
      emit(state.copyWith(
        testResult:   {'success': false, 'message': e.toString()},
        testedMethod: event.methodName,
        clearSaving:  true,
      ));
    }
  }
}
