import '../../domain/entities/plan_entity.dart';

class ActivePromotionModel {
  final String title;
  final String? description;

  final String discountType;
  final double discountValue;

  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  final String? startDate;
  final String? endDate;

  ActivePromotionModel({
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

  factory ActivePromotionModel.fromJson(Map<String, dynamic> json) {
    return ActivePromotionModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      discountType: json['discountType'] as String? ?? '',
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }

  ActivePromotionEntity toEntity() {
    return ActivePromotionEntity(
      title: title,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      originalPrice: originalPrice,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class PlanListItemModel {
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

  final ActivePromotionModel? activePromotion;
  final String? iconName;

  PlanListItemModel({
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

  factory PlanListItemModel.fromJson(Map<String, dynamic> json) {
    return PlanListItemModel(
      planId: (json['planId'] as num).toInt(),
      name: json['name'] as String? ?? '',
      planType: json['planType'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      billingCycle: json['billingCycle'] as String? ?? '',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 0,
      isFeatured: json['isFeatured'] == true,
      features: List<String>.from(json['features'] ?? const []),
      isBooked: json['isBooked'] == true,
      bookingStatus:
      (json['bookingStatus'] as String? ?? 'NONE').toUpperCase(),
      activePromotion: json['activePromotion'] != null
          ? ActivePromotionModel.fromJson(
        json['activePromotion'] as Map<String, dynamic>,
      )
          : null,
      iconName: json['iconName'] as String?,
    );
  }

  PlanEntity toEntity() {
    return PlanEntity(
      planId: planId,
      name: name,
      planType: planType,
      price: price,
      billingCycle: billingCycle,
      durationDays: durationDays,
      isFeatured: isFeatured,
      features: features,
      isBooked: isBooked,
      bookingStatus: bookingStatus,
      activePromotion: activePromotion?.toEntity(),
      iconName: iconName,
    );
  }
}