// =============================================================================
// FILE: membership_package_entity.dart
// PATH: lib/features/admin/members/domain/entities/membership_package_entity.dart
// LAYER: Domain Layer → Entities
// TASK: GA-269
// =============================================================================

class MembershipPackageEntity {
  final String? planName;
  final double  totalAmount;
  final double  discountAmount;
  final String? purchaseDate;
  final double  paidAmount;
  final double  dueAmount;
  final int     remainingDays;

  const MembershipPackageEntity({
    this.planName,
    required this.totalAmount,
    required this.discountAmount,
    this.purchaseDate,
    required this.paidAmount,
    required this.dueAmount,
    required this.remainingDays,
  });

  bool get hasDues      => dueAmount > 0;
  bool get hasDiscount  => discountAmount > 0;
  bool get isExpired    => remainingDays <= 0;
}