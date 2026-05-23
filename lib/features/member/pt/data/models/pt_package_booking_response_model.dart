import '../../domain/entities/pt_package_booking_response_entity.dart';

class PtPackageBookingResponseModel {
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

  const PtPackageBookingResponseModel({
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

  factory PtPackageBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return PtPackageBookingResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      branchId: (json['branchId'] as num?)?.toInt(),
      packageId: (json['packageId'] as num?)?.toInt() ?? 0,
      selectedDays: json['selectedDays'] as String? ?? '',
      selectedTime: json['selectedTime'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      invoiceId: (json['invoiceId'] as num?)?.toInt(),
      transactionId: (json['transactionId'] as num?)?.toInt(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      clientSecret: json['clientSecret'] as String?,
      publishableKey: json['publishableKey'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
    );
  }

  PtPackageBookingResponseEntity toEntity() {
    return PtPackageBookingResponseEntity(
      id: id,
      branchId: branchId,
      packageId: packageId,
      selectedDays: selectedDays,
      selectedTime: selectedTime,
      totalAmount: totalAmount,
      status: status,
      createdAt: createdAt,
      invoiceId: invoiceId,
      transactionId: transactionId,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      clientSecret: clientSecret,
      publishableKey: publishableKey,
      redirectUrl: redirectUrl,
    );
  }
}
