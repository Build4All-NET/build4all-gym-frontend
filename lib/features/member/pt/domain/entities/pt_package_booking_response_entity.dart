/// Domain entity returned after a PT package booking is created.
///
/// Backend example:
/// {
///   "id": 1,
///   "branchId": 1,
///   "packageId": 1,
///   "selectedDays": "[{\"day\":\"Sunday\",\"date\":\"2026-05-10\"}]",
///   "selectedTime": "17:00",
///   "totalAmount": 140.00,
///   "status": "PENDING",
///   "createdAt": "2026-05-09T12:00:00"
/// }
class PtPackageBookingResponseEntity {
  final int id;
  final int? branchId;
  final int packageId;
  final String selectedDays;
  final String selectedTime;
  final double totalAmount;
  final String status;
  final String? createdAt;

  const PtPackageBookingResponseEntity({
    required this.id,
    this.branchId,
    required this.packageId,
    required this.selectedDays,
    required this.selectedTime,
    required this.totalAmount,
    required this.status,
    this.createdAt,
  });
}