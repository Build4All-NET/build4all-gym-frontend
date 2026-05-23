class PtPackageBookingRequestModel {
  final int packageId;
  final List<Map<String, dynamic>> weeklySchedule;

  /// Optional: CASH, STRIPE, PAYPAL, MPGS.
  /// If null, backend creates booking without initiating payment (legacy).
  final String? paymentMethod;

  const PtPackageBookingRequestModel({
    required this.packageId,
    required this.weeklySchedule,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'weeklySchedule': weeklySchedule,
      if (paymentMethod != null && paymentMethod!.isNotEmpty)
        'paymentMethod': paymentMethod,
    };
  }
}
