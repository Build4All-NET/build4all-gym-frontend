class MembershipRequestEntity {
  final int requestId;
  final String memberName;
  final String memberEmail;
  final String planName;
  final String branchName;
  final double totalAmount;
  final String status;
  final String requestedAt;

  const MembershipRequestEntity({
    required this.requestId,
    required this.memberName,
    required this.memberEmail,
    required this.planName,
    required this.branchName,
    required this.totalAmount,
    required this.status,
    required this.requestedAt,
  });
}
