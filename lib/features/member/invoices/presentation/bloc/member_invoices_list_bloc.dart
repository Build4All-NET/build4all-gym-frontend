import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_invoice_entity.dart';
import '../../domain/usecases/member_invoice_usecases.dart';
import 'member_invoices_list_event.dart';
import 'member_invoices_list_state.dart';

/// Bloc for member payment history.
///
/// Responsibilities:
/// - load invoices
/// - refresh invoices
/// - send refund request
/// - reload list after refund request succeeds
class MemberInvoicesListBloc
    extends Bloc<MemberInvoicesListEvent, MemberInvoicesListState> {
  final ListMemberInvoicesUseCase _listInvoicesUseCase;
  final RequestMemberRefundUseCase _requestRefundUseCase;

  MemberInvoicesListBloc({
    required ListMemberInvoicesUseCase listInvoicesUseCase,
    required RequestMemberRefundUseCase requestRefundUseCase,
  })  : _listInvoicesUseCase = listInvoicesUseCase,
        _requestRefundUseCase = requestRefundUseCase,
        super(const MemberInvoicesListInitial()) {
    on<LoadMemberInvoicesEvent>(_onLoadInvoices);
    on<RefreshMemberInvoicesEvent>(_onRefreshInvoices);
    on<RequestMemberRefundEvent>(_onRequestRefund);
  }

  Future<void> _onLoadInvoices(
      LoadMemberInvoicesEvent event,
      Emitter<MemberInvoicesListState> emit,
      ) async {
    emit(const MemberInvoicesListLoading());

    try {
      final invoices = await _listInvoicesUseCase(
        page: event.page,
        size: event.size,
        status: event.status,
        type: event.type,
      );

      emit(MemberInvoicesListLoaded(invoices: invoices));
    } catch (_) {
      emit(const MemberInvoicesListError());
    }
  }

  Future<void> _onRefreshInvoices(
      RefreshMemberInvoicesEvent event,
      Emitter<MemberInvoicesListState> emit,
      ) async {
    try {
      final invoices = await _listInvoicesUseCase(
        page: 0,
        size: 50,
        status: event.status,
        type: event.type,
      );

      emit(MemberInvoicesListLoaded(invoices: invoices));
    } catch (_) {
      emit(const MemberInvoicesListError());
    }
  }

  Future<void> _onRequestRefund(
      RequestMemberRefundEvent event,
      Emitter<MemberInvoicesListState> emit,
      ) async {
    final currentState = state;

    List<MemberInvoiceSummaryEntity> currentInvoices = const [];

    if (currentState is MemberInvoicesListLoaded) {
      currentInvoices = currentState.invoices;
    }

    emit(
      MemberRefundRequesting(
        invoices: currentInvoices,
        invoiceId: event.invoiceId,
      ),
    );

    try {
      await _requestRefundUseCase(
        invoiceId: event.invoiceId,
        reason: event.reason,
      );

      // Reload with same filters after refund request succeeds.
      final invoices = await _listInvoicesUseCase(
        page: 0,
        size: 50,
        status: event.status,
        type: event.type,
      );

      emit(MemberInvoicesListLoaded(invoices: invoices));
    } catch (_) {
      emit(const MemberInvoicesListError());
    }
  }
}