import '../../domain/entities/member_invoice_entity.dart';

/// UI states for member payment history screen.
abstract class MemberInvoicesListState {
  const MemberInvoicesListState();
}

/// Initial state before loading.
class MemberInvoicesListInitial extends MemberInvoicesListState {
  const MemberInvoicesListInitial();
}

/// Loading invoices from backend.
class MemberInvoicesListLoading extends MemberInvoicesListState {
  const MemberInvoicesListLoading();
}

/// Invoices loaded successfully.
class MemberInvoicesListLoaded extends MemberInvoicesListState {
  final List<MemberInvoiceSummaryEntity> invoices;

  const MemberInvoicesListLoaded({
    required this.invoices,
  });
}

/// Refund request is being sent.
///
/// We keep current invoices on screen and only disable the clicked button.
class MemberRefundRequesting extends MemberInvoicesListState {
  final List<MemberInvoiceSummaryEntity> invoices;
  final int invoiceId;

  const MemberRefundRequesting({
    required this.invoices,
    required this.invoiceId,
  });
}

/// Generic error state.
/// Visible text is handled in the screen using localization.
class MemberInvoicesListError extends MemberInvoicesListState {
  const MemberInvoicesListError();
}