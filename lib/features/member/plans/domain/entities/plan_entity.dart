class ActivePromotionEntity {
  final String title;
  final String? description;

  final String discountType;
  final double discountValue;

  /// These values come from backend.
  /// Flutter displays them only.
  /// Flutter should not calculate the promotion price.
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  final String? startDate;
  final String? endDate;

  const ActivePromotionEntity({
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    this.startDate,
    this.endDate,
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
  final bool isBooked;
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
    required this.isBooked,
    this.activePromotion,
    this.iconName,
  });

  /// Price shown in the UI.
  /// If promotion exists, show backend finalPrice.
  /// Otherwise show normal price.
  double get displayPrice {
    return activePromotion?.finalPrice ?? price;
  }

  /// Cleaner UI condition.
  bool get hasActivePromotion {
    return activePromotion != null;
  }
}