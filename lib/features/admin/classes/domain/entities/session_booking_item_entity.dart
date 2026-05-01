
class SessionBookingItemEntity {
  final int     bookingId;
  final int     userId;
  final String  fullName;
  final String  phone;
  final int?    profileFileId;
  final String  status;
  final int?    waitlistPosition;

  const SessionBookingItemEntity({
    required this.bookingId,
    required this.userId,
    required this.fullName,
    required this.phone,
    this.profileFileId,
    required this.status,
    this.waitlistPosition,
  });
}
