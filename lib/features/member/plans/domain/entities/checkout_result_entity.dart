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

  // Online payment fields — populated for STRIPE / PAYPAL / MPGS
  final int?    transactionId;
  final String? redirectUrl;
  final String? clientSecret;
  final String? publishableKey;

  bool get isPending  => membershipStatus.toLowerCase() == 'pending';
  bool get isStripe   => clientSecret != null && publishableKey != null;
  bool get isRedirect => redirectUrl != null && !isStripe;

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
    this.transactionId,
    this.redirectUrl,
    this.clientSecret,
    this.publishableKey,
  });

  CheckoutResultEntity copyWithStatus(String membershipStatus, String paymentStatus) {
    return CheckoutResultEntity(
      membershipId:     membershipId,
      invoiceId:        invoiceId,
      invoiceNumber:    invoiceNumber,
      planName:         planName,
      startDate:        startDate,
      endDate:          endDate,
      originalPrice:    originalPrice,
      discountAmount:   discountAmount,
      totalAmount:      totalAmount,
      membershipStatus: membershipStatus,
      paymentStatus:    paymentStatus,
    );
  }
}