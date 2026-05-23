class PtPackageBookingResponseEntity {
  final int id;
  final int? branchId;
  final int packageId;
  final String selectedDays;
  final String selectedTime;
  final double totalAmount;
  final String status;
  final String? createdAt;

  // Payment fields
  final int? invoiceId;
  final int? transactionId;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? clientSecret;
  final String? publishableKey;
  final String? redirectUrl;

  const PtPackageBookingResponseEntity({
    required this.id,
    this.branchId,
    required this.packageId,
    required this.selectedDays,
    required this.selectedTime,
    required this.totalAmount,
    required this.status,
    this.createdAt,
    this.invoiceId,
    this.transactionId,
    this.paymentMethod,
    this.paymentStatus,
    this.clientSecret,
    this.publishableKey,
    this.redirectUrl,
  });

  bool get isPending =>
      paymentStatus?.toUpperCase() == 'PENDING' ||
      status.toUpperCase() == 'PENDING';
  bool get isStripe   => paymentMethod?.toUpperCase() == 'STRIPE';
  bool get isRedirect =>
      paymentMethod?.toUpperCase() == 'PAYPAL' ||
      paymentMethod?.toUpperCase() == 'MPGS';
}
