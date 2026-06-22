import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_invoice_entity.dart';
import '../../domain/usecases/admin_invoice_usecases.dart';

part 'admin_invoice_event.dart';
part 'admin_invoice_state.dart';

class AdminInvoiceBloc extends Bloc<AdminInvoiceEvent, AdminInvoiceState> {
  final GetInvoiceUseCase _getInvoice;
  final RecordInvoicePaymentUseCase _recordInvoicePayment;

  AdminInvoiceBloc({
    required GetInvoiceUseCase getInvoice,
    required RecordInvoicePaymentUseCase recordInvoicePayment,
  })  : _getInvoice = getInvoice,
        _recordInvoicePayment = recordInvoicePayment,
        super(AdminInvoiceInitial()) {
    on<LoadInvoiceEvent>(_onLoad);
    on<RecordInvoicePaymentEvent>(_onRecordPayment);
  }

  Future<void> _onLoad(
    LoadInvoiceEvent event,
    Emitter<AdminInvoiceState> emit,
  ) async {
    emit(AdminInvoiceLoading());
    try {
      final invoice = await _getInvoice(event.invoiceId);
      emit(AdminInvoiceLoaded(invoice));
    } catch (e) {
      emit(AdminInvoiceError(_extractMessage(e)));
    }
  }

  Future<void> _onRecordPayment(
    RecordInvoicePaymentEvent event,
    Emitter<AdminInvoiceState> emit,
  ) async {
    try {
      final invoice = await _recordInvoicePayment(
          event.invoiceId, event.amount, notes: event.notes);
      emit(AdminInvoiceLoaded(invoice, wasPaymentRecorded: true));
    } catch (e) {
      emit(AdminInvoiceError(_extractMessage(e)));
    }
  }

  String _extractMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final msg = data['message'] as String?
            ?? data['error'] as String?
            ?? data['detail'] as String?;
        if (msg != null && msg.isNotEmpty) return msg;
      }
      if (data is String && data.isNotEmpty) return data;
      return e.message ?? e.toString();
    }
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.replaceFirst('Exception: ', '') : msg;
  }
}
