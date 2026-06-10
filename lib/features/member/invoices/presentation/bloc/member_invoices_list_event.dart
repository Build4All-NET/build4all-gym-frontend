/// Events for member payment history screen.
///
/// UI sends these events to the Bloc:
/// - load invoices
/// - refresh invoices
/// - request refund
abstract class MemberInvoicesListEvent {
  const MemberInvoicesListEvent();
}

/// Load payment history.
class LoadMemberInvoicesEvent extends MemberInvoicesListEvent {
  final int page;
  final int size;
  final String? status;
  final String? type;

  const LoadMemberInvoicesEvent({
    this.page = 0,
    this.size = 50,
    this.status,
    this.type,
  });
}

/// Refresh payment history with current filters.
class RefreshMemberInvoicesEvent extends MemberInvoicesListEvent {
  final String? status;
  final String? type;

  const RefreshMemberInvoicesEvent({
    this.status,
    this.type,
  });
}

/// Member clicks refund button.
///
/// Backend creates refund request with status = pending.
/// It does not refund directly.
class RequestMemberRefundEvent extends MemberInvoicesListEvent {
  final int invoiceId;
  final String? reason;

  /// Keep current filters after refund request.
  final String? status;
  final String? type;

  const RequestMemberRefundEvent({
    required this.invoiceId,
    this.reason,
    this.status,
    this.type,
  });
}