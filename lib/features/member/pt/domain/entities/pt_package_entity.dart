/// Domain entity for a PT package shown in trainer detail.
///
/// This object is used by the app internally.
/// No JSON parsing here.
///
/// Important:
/// - package name comes from backend/admin/PT and can be any language.
/// - do not use package name or packageType for logic.
/// - booking limits come from minDaysPerWeek and maxDaysPerWeek.
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

  const PtPackageEntity({
    required this.id,
    required this.trainerId,
    required this.branchId,
    required this.name,
    required this.packageType,
    required this.numberOfSessions,
    required this.daysAvailable,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    required this.price,
    required this.salePrice,
    required this.finalPrice,
  });
}