class MyMembershipEntity {
  final int membershipId;
  final String planName;
  final String planType;
  final String status;
  final String startDate;
  final String endDate;
  final int remainingDays;
  final int? remainingVisits;
  final int frozenDaysUsed;
  final bool autoRenewEnabled;
  final String paymentStatus;

  const MyMembershipEntity({
    required this.membershipId,
    required this.planName,
    required this.planType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
    this.remainingVisits,
    required this.frozenDaysUsed,
    required this.autoRenewEnabled,
    required this.paymentStatus,
  });
}