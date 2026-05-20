class BookSessionModel {
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

  const BookSessionModel({
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

  factory BookSessionModel.fromJson(Map<String, dynamic> json) {
    return BookSessionModel(
      bookingId:        json['bookingId']        as int,
      status:           json['status']           as String,
      waitlistPosition: json['waitlistPosition'] as int?,
      paymentStatus:    json['paymentStatus']    as String?,
      paymentMethod:    json['paymentMethod']    as String?,
      invoiceId:        json['invoiceId']        as int?,
      transactionId:    json['transactionId']    as int?,
      clientSecret:     json['clientSecret']     as String?,
      publishableKey:   json['publishableKey']   as String?,
      redirectUrl:      json['redirectUrl']      as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId':        bookingId,
      'status':           status,
      'waitlistPosition': waitlistPosition,
      'paymentStatus':    paymentStatus,
      'paymentMethod':    paymentMethod,
      'invoiceId':        invoiceId,
      'transactionId':    transactionId,
      'clientSecret':     clientSecret,
      'publishableKey':   publishableKey,
      'redirectUrl':      redirectUrl,
    };
  }
}