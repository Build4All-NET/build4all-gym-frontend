import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_invoice_entity.dart';
import '../../domain/usecases/admin_invoice_usecases.dart';

part 'admin_invoices_list_event.dart';
part 'admin_invoices_list_state.dart';

class AdminInvoicesListBloc
    extends Bloc<AdminInvoicesListEvent, AdminInvoicesListState> {
  final ListInvoicesUseCase _listInvoices;

  AdminInvoicesListBloc({required ListInvoicesUseCase listInvoices})
      : _listInvoices = listInvoices,
        super(AdminInvoicesListInitial()) {
    on<LoadInvoicesListEvent>(_onLoad);
    on<FilterInvoicesEvent>(_onFilter);
  }

  Future<void> _onLoad(
    LoadInvoicesListEvent event,
    Emitter<AdminInvoicesListState> emit,
  ) async {
    emit(AdminInvoicesListLoading());
    try {
      final invoices = await _listInvoices(status: event.status);
      emit(AdminInvoicesListLoaded(invoices, selectedStatus: event.status));
    } catch (e) {
      emit(AdminInvoicesListError(_extractMessage(e)));
    }
  }

  Future<void> _onFilter(
    FilterInvoicesEvent event,
    Emitter<AdminInvoicesListState> emit,
  ) async {
    emit(AdminInvoicesListLoading());
    try {
      final invoices = await _listInvoices(status: event.status);
      emit(AdminInvoicesListLoaded(invoices, selectedStatus: event.status));
    } catch (e) {
      emit(AdminInvoicesListError(_extractMessage(e)));
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
