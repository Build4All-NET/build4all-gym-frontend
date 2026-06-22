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
  final double? price;

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
    this.price,
  });

  factory SessionBookingItemModel.fromJson(Map<String, dynamic> json) {
    return SessionBookingItemModel(
      bookingId:        (json['bookingId']        as num?)?.toInt() ?? 0,
      userId:           (json['userId']           as num?)?.toInt() ?? 0,
      fullName:         json['fullName']         as String? ?? 'Unknown',
      phone:            json['phone']            as String? ?? '',
      profileFileId:    (json['profileFileId']   as num?)?.toInt(),
      status:           json['status']           as String? ?? 'BOOKED',
      waitlistPosition: (json['waitlistPosition'] as num?)?.toInt(),
      paymentStatus:    json['paymentStatus']    as String?,
      paymentMethod:    json['paymentMethod']    as String?,
      invoiceId:        (json['invoiceId']       as num?)?.toInt(),
      price:            (json['price']           as num?)?.toDouble(),
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
    'price':            price,
  };
}