class MyMembershipEntity {
  final int membershipId;

  /*
   * Needed for membership renewal.
   *
   * When the current membership is expired, the Renew button uses this planId
   * to open the same Plan Detail / payment flow as Select This Plan.
   */
  final int planId;

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
    required this.planId,
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