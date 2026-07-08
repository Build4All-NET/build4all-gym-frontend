class ActivePromotionEntity {
  final String title;
  final String? description;

  final String discountType;
  final double discountValue;

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
  final String bookingStatus;

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
    required this.bookingStatus,
    this.activePromotion,
    this.iconName,
  });

  bool get isPending => bookingStatus.toUpperCase() == 'PENDING';
  bool get isActiveBooked => bookingStatus.toUpperCase() == 'BOOKED';
  bool get canSelect => bookingStatus.toUpperCase() == 'NONE';

  double get displayPrice => activePromotion?.finalPrice ?? price;
  bool get hasActivePromotion => activePromotion != null;
}