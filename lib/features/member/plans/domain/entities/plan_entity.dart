class ActivePromotionEntity {
  final String title;
  final String discountType;
  final double discountValue;

  const ActivePromotionEntity({
    required this.title,
    required this.discountType,
    required this.discountValue,
  });
}

class PlanEntity {
  final int planId;
  final String name;
  final String planType;
  final double price;
  final String billingCycle;
  final int durationDays;
  final bool isFeatured;
  final List<String> features;
  final ActivePromotionEntity? activePromotion;
  final String? iconName;

  const PlanEntity({
    required this.planId,
    required this.name,
    required this.planType,
    required this.price,
    required this.billingCycle,
    required this.durationDays,
    required this.isFeatured,
    required this.features,
    this.activePromotion,
    this.iconName,
  });
}
