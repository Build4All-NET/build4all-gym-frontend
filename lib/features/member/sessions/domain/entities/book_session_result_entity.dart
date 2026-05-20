class BookSessionResultEntity {
  final int bookingId;
  final String status;
  final int? waitlistPosition;
  final String? paymentStatus;
  final String? paymentMethod;
  final int? invoiceId;
  final int? transactionId;
  final String? clientSecret;
  final String? publishableKey;
  final String? redirectUrl;

  const BookSessionResultEntity({
    required this.bookingId,
    required this.status,
    this.waitlistPosition,
    this.paymentStatus,
    this.paymentMethod,
    this.invoiceId,
    this.transactionId,
    this.clientSecret,
    this.publishableKey,
    this.redirectUrl,
  });

  bool get isPending => paymentStatus?.toUpperCase() == 'PENDING' || status.toUpperCase() == 'PENDING';
  bool get isStripe   => paymentMethod?.toUpperCase() == 'STRIPE';
  bool get isRedirect => paymentMethod?.toUpperCase() == 'PAYPAL' || paymentMethod?.toUpperCase() == 'MPGS';
}