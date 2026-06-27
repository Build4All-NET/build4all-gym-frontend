class MemberMembershipEntity {
  final int membershipId;
  final int planId;

  final String planName;
  final String planType;

  final String status;
  final String paymentStatus;

  final DateTime? startDate;
  final DateTime? endDate;

  final int remainingDays;
  final int? remainingVisits;
  final int? durationDays;

  final String? billingCycle;
  final double price;
  final String? branchName;

  final bool autoRenewEnabled;

  const MemberMembershipEntity({
    required this.membershipId,
    required this.planId,
    required this.planName,
    required this.planType,
    required this.status,
    required this.paymentStatus,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
    required this.remainingVisits,
    required this.durationDays,
    required this.billingCycle,
    required this.price,
    required this.branchName,
    required this.autoRenewEnabled,
  });
}