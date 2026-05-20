import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/payment_method_config_model.dart';
import '../../data/services/admin_payment_config_service.dart';

abstract class AdminPaymentConfigState {}

class AdminPaymentConfigInitial extends AdminPaymentConfigState {}
class AdminPaymentConfigLoading extends AdminPaymentConfigState {}
class AdminPaymentConfigLoaded extends AdminPaymentConfigState {
  final List<PaymentMethodConfigModel> methods;
  final String? savingMethod;
  AdminPaymentConfigLoaded({required this.methods, this.savingMethod});
}
class AdminPaymentConfigError extends AdminPaymentConfigState {
  final String message;
  AdminPaymentConfigError(this.message);
}

class AdminPaymentConfigCubit extends Cubit<AdminPaymentConfigState> {
  final AdminPaymentConfigService _service;

  AdminPaymentConfigCubit(this._service) : super(AdminPaymentConfigInitial());

  Future<void> load() async {
    emit(AdminPaymentConfigLoading());
    try {
      final methods = await _service.getPaymentMethods();
      emit(AdminPaymentConfigLoaded(methods: methods));
    } catch (e) {
      emit(AdminPaymentConfigError(e.toString()));
    }
  }

  Future<void> toggleMethod(PaymentMethodConfigModel method, bool enabled) async {
    final current = state;
    if (current is! AdminPaymentConfigLoaded) return;

    emit(AdminPaymentConfigLoaded(methods: current.methods, savingMethod: method.name));
    try {
      final updated = await _service.saveConfig(
        method.name,
        enabled,
        configJson: method.configJson,
      );
      final newList = current.methods.map((m) => m.name == updated.name ? updated : m).toList();
      emit(AdminPaymentConfigLoaded(methods: newList));
    } catch (e) {
      emit(AdminPaymentConfigLoaded(methods: current.methods));
    }
  }

  Future<bool> saveCredentials(
    PaymentMethodConfigModel method,
    String configJson,
  ) async {
    final current = state;
    if (current is! AdminPaymentConfigLoaded) return false;

    emit(AdminPaymentConfigLoaded(methods: current.methods, savingMethod: method.name));
    try {
      final updated = await _service.saveConfig(
        method.name,
        method.tenantEnabled,
        configJson: configJson,
      );
      final newList = current.methods.map((m) => m.name == updated.name ? updated : m).toList();
      emit(AdminPaymentConfigLoaded(methods: newList));
      return true;
    } catch (e) {
      emit(AdminPaymentConfigLoaded(methods: current.methods));
      return false;
    }
  }

  Future<({bool ok, String? error})> testConnection(String methodName) async {
    return _service.testConnection(methodName);
  }
}
