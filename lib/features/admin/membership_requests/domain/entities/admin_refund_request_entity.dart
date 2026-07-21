class AdminRefundRequestEntity {
  final int refundId;
  final String memberName;
  final String memberEmail;
  final String planName;
  final double requestedAmount;
  final String? reason;
  final String createdAt;
  // e.g. PT_PACKAGE, PLAN, CLASS
  final String? type;

  const AdminRefundRequestEntity({
    required this.refundId,
    required this.memberName,
    required this.memberEmail,
    required this.planName,
    required this.requestedAmount,
    this.reason,
    required this.createdAt,
    this.type,
  });
}

/// Outcome of POST /api/admin/refund-requests/{id}/approve.
///
/// The endpoint always returns HTTP 200 — even when the payment provider
/// (PayPal/MPGS) has no refund API available yet — so callers must check
/// [succeeded] instead of assuming a 200 response means the member's money
/// was actually returned.
class RefundApprovalResult {
  final bool succeeded;
  final String? errorCode;

  const RefundApprovalResult({required this.succeeded, this.errorCode});
}
