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
