class CouponValidationEntity {
  final bool valid;
  final String? discountType;
  final double? discountValue;
  final double? originalPrice;
  final double? finalPrice;
  final String message;

  const CouponValidationEntity({
    required this.valid,
    this.discountType,
    this.discountValue,
    this.originalPrice,
    this.finalPrice,
    required this.message,
  });
}