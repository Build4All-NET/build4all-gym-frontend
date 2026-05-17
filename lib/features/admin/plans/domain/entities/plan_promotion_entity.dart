class PlanPromotionEntity {
  final int? promotionId;
  final String title;
  final String? description;
  final String discountType; // "fixed" or "percentage"
  final double discountValue;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  const PlanPromotionEntity({
    this.promotionId,
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.startDate,
    this.endDate,
    this.isActive = true,
  });
}
