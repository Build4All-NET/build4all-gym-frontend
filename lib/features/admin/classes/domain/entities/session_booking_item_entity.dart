
class SessionBookingItemEntity {
  final int     bookingId;
  final int     userId;
  final String  fullName;
  final String  phone;
  final int?    profileFileId;
  final String  status;
  final int?    waitlistPosition;
  final String? paymentStatus;
  final String? paymentMethod;
  final int?    invoiceId;

  const SessionBookingItemEntity({
    required this.bookingId,
    required this.userId,
    required this.fullName,
    required this.phone,
    this.profileFileId,
    required this.status,
    this.waitlistPosition,
    this.paymentStatus,
    this.paymentMethod,
    this.invoiceId,
  });

  bool get isCashPending =>
      paymentMethod?.toUpperCase() == 'CASH' &&
      (paymentStatus?.toUpperCase() == 'PENDING' || paymentStatus?.toUpperCase() == 'UNPAID');
}
