// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/models/session_booking_item_model.dart
//
// PURPOSE:
//   Maps ONE row returned by GET /api/admin/classes/{sessionId}/bookings.
//   Each row represents a single member's booking for that class session.
// ─────────────────────────────────────────────────────────────────────────────

class SessionBookingItemModel {
  final int     bookingId;
  final int     userId;
  final String  fullName;
  final String?  phone;
  final int?    profileFileId;
  final String  status;
  final int?    waitlistPosition;
  final String? paymentStatus;
  final String? paymentMethod;
  final int?    invoiceId;

  const SessionBookingItemModel({
    required this.bookingId,
    required this.userId,
    required this.fullName,
    this.phone,
    this.profileFileId,
    required this.status,
    this.waitlistPosition,
    this.paymentStatus,
    this.paymentMethod,
    this.invoiceId,
  });

  factory SessionBookingItemModel.fromJson(Map<String, dynamic> json) {
    return SessionBookingItemModel(
      bookingId:        json['bookingId']        as int,
      userId:           json['userId']           as int,
      fullName:         json['fullName']         as String? ?? 'Unknown',
      phone:            json['phone']            as String? ?? '',
      profileFileId:    json['profileFileId']    as int?,
      status:           json['status']           as String? ?? 'BOOKED',
      waitlistPosition: json['waitlistPosition'] as int?,
      paymentStatus:    json['paymentStatus']    as String?,
      paymentMethod:    json['paymentMethod']    as String?,
      invoiceId:        json['invoiceId']        as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'bookingId':        bookingId,
    'userId':           userId,
    'fullName':         fullName,
    'phone':            phone,
    'profileFileId':    profileFileId,
    'status':           status,
    'waitlistPosition': waitlistPosition,
    'paymentStatus':    paymentStatus,
    'paymentMethod':    paymentMethod,
    'invoiceId':        invoiceId,
  };
}