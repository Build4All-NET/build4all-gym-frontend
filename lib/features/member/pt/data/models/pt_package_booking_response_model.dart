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

  const PtPackageBookingResponseModel({
    required this.id,
    this.branchId,
    required this.packageId,
    required this.selectedDays,
    required this.selectedTime,
    required this.totalAmount,
    required this.status,
    this.createdAt,
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
    );
  }
}