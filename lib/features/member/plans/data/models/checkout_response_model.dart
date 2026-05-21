class CheckoutResponseModel {
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

  // Online payment fields (null for CASH)
  final int?    transactionId;
  final String? redirectUrl;
  final String? clientSecret;
  final String? publishableKey;

  CheckoutResponseModel({
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

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckoutResponseModel(
      membershipId:    json['membershipId'] as int,
      invoiceId:       json['invoiceId'] as int,
      invoiceNumber:   json['invoiceNumber'] as String,
      planName:        json['planName'] as String,
      startDate:       json['startDate'] as String,
      endDate:         json['endDate'] as String,
      originalPrice:   (json['originalPrice'] as num).toDouble(),
      discountAmount:  (json['discountAmount'] as num).toDouble(),
      totalAmount:     (json['totalAmount'] as num).toDouble(),
      membershipStatus: json['membershipStatus'] as String,
      paymentStatus:   json['paymentStatus'] as String,
      transactionId:   json['transactionId'] as int?,
      redirectUrl:     json['redirectUrl']  as String?,
      clientSecret:    json['clientSecret'] as String?,
      publishableKey:  json['publishableKey'] as String?,
    );
  }
}