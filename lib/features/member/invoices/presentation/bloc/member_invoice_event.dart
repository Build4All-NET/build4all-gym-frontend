/// Events for the member invoice details screen.
///
/// UI sends this event when the member clicks "View Details".
abstract class MemberInvoiceEvent {
  const MemberInvoiceEvent();
}

/// Load one full invoice by ID.
///
/// Backend endpoint:
/// GET /api/member/invoices/{invoiceId}
class LoadMemberInvoiceEvent extends MemberInvoiceEvent {
  final int invoiceId;

  const LoadMemberInvoiceEvent({
    required this.invoiceId,
  });
}