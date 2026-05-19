class CheckoutResultEntity {
  final int membershipId;
  final int invoiceId;
  final String invoiceNumber;
  final String planName;
  final String startDate;
  final String endDate;
  final double originalPrice;
  final double discountAmount;
  final double totalAmount;
  final String membershipStatus;
  final String paymentStatus;

  bool get isPending => membershipStatus.toLowerCase() == 'pending';

  CheckoutResultEntity({
    required this.membershipId,
    required this.invoiceId,
    required this.invoiceNumber,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.originalPrice,
    required this.discountAmount,
    required this.totalAmount,
    required this.membershipStatus,
    required this.paymentStatus,
  });
}
