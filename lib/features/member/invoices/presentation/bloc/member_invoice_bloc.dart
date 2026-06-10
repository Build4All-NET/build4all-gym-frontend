import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/member_invoice_usecases.dart';
import 'member_invoice_event.dart';
import 'member_invoice_state.dart';

/// Bloc for member invoice details screen.
///
/// Responsibilities:
/// - load one invoice by ID
/// - expose loading / loaded / error states to the UI
class MemberInvoiceBloc extends Bloc<MemberInvoiceEvent, MemberInvoiceState> {
  final GetMemberInvoiceUseCase _getInvoiceUseCase;

  MemberInvoiceBloc({
    required GetMemberInvoiceUseCase getInvoiceUseCase,
  })  : _getInvoiceUseCase = getInvoiceUseCase,
        super(const MemberInvoiceInitial()) {
    on<LoadMemberInvoiceEvent>(_onLoadInvoice);
  }

  /// Loads one invoice from backend.
  Future<void> _onLoadInvoice(
      LoadMemberInvoiceEvent event,
      Emitter<MemberInvoiceState> emit,
      ) async {
    emit(const MemberInvoiceLoading());

    try {
      final invoice = await _getInvoiceUseCase(event.invoiceId);

      emit(MemberInvoiceLoaded(invoice: invoice));
    } catch (_) {
      emit(const MemberInvoiceError('generic'));
    }
  }
}