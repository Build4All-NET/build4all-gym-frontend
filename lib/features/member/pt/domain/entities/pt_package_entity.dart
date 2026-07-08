/// Domain entity for a PT package shown in trainer detail.
///
/// This object is used by the app internally.
/// No JSON parsing here.
///
/// Important:
/// - package name comes from backend/admin/PT and can be any language.
/// - do not use package name or packageType for logic.
/// - booking limits come from minDaysPerWeek and maxDaysPerWeek.
/// - bookingStatus is specific to this exact package.
class PtPackageEntity {
  final int id;
  final int trainerId;
  final int branchId;

  /// Display-only name.
  /// Example: "باقة أسبوع", "Monthly Package", "Custom Plan".
  final String name;

  /// Optional metadata.
  /// Do not use this for booking logic.
  final String packageType;

  /// Total number of services in this package.
  /// Example: 16 services.
  final int numberOfSessions;

  /// Package validity duration in days.
  /// Example: 112 days.
  final int daysAvailable;

  /// Session duration in minutes.
  /// Example: 60, 90. Null means default (60).
  final int? sessionDurationMinutes;

  /// Minimum number of days/week the member must choose.
  /// Example: 1.
  final int minDaysPerWeek;

  /// Maximum number of days/week the member can choose.
  /// Example: 2.
  final int maxDaysPerWeek;

  /// Normal price.
  final double price;

  /// Discounted price.
  /// Can be null.
  final double? salePrice;

  /// Backend-calculated final price.
  /// salePrice if exists, otherwise price.
  final double finalPrice;

  /// Current booking state for this exact package.
  ///
  /// Expected values:
  /// NONE
  /// PENDING
  /// ACTIVE
  /// BOOKED
  /// CANCEL_REQUESTED
  /// CANCELLED
  /// COMPLETED
  final String bookingStatus;

  const PtPackageEntity({
    required this.id,
    required this.trainerId,
    required this.branchId,
    required this.name,
    required this.packageType,
    required this.numberOfSessions,
    required this.daysAvailable,
    this.sessionDurationMinutes,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    required this.price,
    required this.salePrice,
    required this.finalPrice,
    required this.bookingStatus,
  });

  bool get isPending => bookingStatus.toUpperCase() == 'PENDING';

  bool get isActive {
    final status = bookingStatus.toUpperCase();

    return status == 'ACTIVE' || status == 'BOOKED';
  }

  bool get isCancelRequested {
    return bookingStatus.toUpperCase() == 'CANCEL_REQUESTED';
  }

  bool get isBookingDisabled {
    return isPending || isActive || isCancelRequested;
  }
  PtPackageEntity copyWith({
    int? id,
    int? trainerId,
    int? branchId,
    String? name,
    String? packageType,
    int? numberOfSessions,
    int? daysAvailable,
    int? sessionDurationMinutes,
    int? minDaysPerWeek,
    int? maxDaysPerWeek,
    double? price,
    double? salePrice,
    double? finalPrice,
    String? bookingStatus,
  }) {
    return PtPackageEntity(
      id: id ?? this.id,
      trainerId: trainerId ?? this.trainerId,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      packageType: packageType ?? this.packageType,
      numberOfSessions:
      numberOfSessions ?? this.numberOfSessions,
      daysAvailable: daysAvailable ?? this.daysAvailable,
      sessionDurationMinutes:
      sessionDurationMinutes ?? this.sessionDurationMinutes,
      minDaysPerWeek:
      minDaysPerWeek ?? this.minDaysPerWeek,
      maxDaysPerWeek:
      maxDaysPerWeek ?? this.maxDaysPerWeek,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      finalPrice: finalPrice ?? this.finalPrice,
      bookingStatus:
      bookingStatus ?? this.bookingStatus,
    );
  }
}