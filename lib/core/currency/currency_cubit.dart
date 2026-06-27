// lib/core/currency/currency_cubit.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/env.dart';
import 'currency_info.dart';
import 'currency_service.dart';

export 'currency_info.dart';

class CurrencyState {
  final CurrencyInfo info;
  final bool isLoaded;

  const CurrencyState({required this.info, required this.isLoaded});

  factory CurrencyState.initial() =>
      const CurrencyState(info: CurrencyInfo.fallback, isLoaded: false);

  CurrencyState copyWith({CurrencyInfo? info, bool? isLoaded}) {
    return CurrencyState(
      info: info ?? this.info,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Loads the gym's configured currency (Env.currencyId) once at startup from
/// the build4all backend, so screens can show the right symbol/code instead
/// of a hardcoded one.
class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyService _service;

  CurrencyCubit({CurrencyService? service})
      : _service = service ?? CurrencyService(Dio()),
        super(CurrencyState.initial()) {
    loadCurrency();
  }

  Future<void> loadCurrency() async {
    final apiBaseUrl = Env.apiBaseUrl.trim();
    final currencyId = Env.currencyId.trim();

    if (apiBaseUrl.isEmpty || currencyId.isEmpty) {
      emit(state.copyWith(isLoaded: true));
      return;
    }

    try {
      final info = await _service.fetchById(
        apiBaseUrl: apiBaseUrl,
        currencyId: currencyId,
      );
      emit(state.copyWith(info: info, isLoaded: true));
    } catch (e) {
      print('Currency load failed: $e');
      emit(state.copyWith(isLoaded: true));
    }
  }
}
