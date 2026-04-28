import '../../domain/entities/active_promotion_entity.dart';
import '../../domain/entities/plan_entity.dart';

class ActivePromotionModel {
  final String title;
  final String discountType;
  final double discountValue;

  ActivePromotionModel({
    required this.title,
    required this.discountType,
    required this.discountValue,
  });

  factory ActivePromotionModel.fromJson(Map<String, dynamic> json) {
    return ActivePromotionModel(
      title: json['title'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
    );
  }

  ActivePromotionEntity toEntity() {
    return ActivePromotionEntity(
      title: title,
      discountType: discountType,
      discountValue: discountValue,
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
  final ActivePromotionModel? activePromotion;

  PlanListItemModel({
    required this.planId,
    required this.name,
    required this.planType,
    required this.price,
    required this.billingCycle,
    required this.durationDays,
    required this.isFeatured,
    required this.features,
    this.activePromotion,
  });

  factory PlanListItemModel.fromJson(Map<String, dynamic> json) {
    return PlanListItemModel(
      planId: json['planId'] as int,
      name: json['name'] as String,
      planType: json['planType'] as String,
      price: (json['price'] as num).toDouble(),
      billingCycle: json['billingCycle'] as String,
      durationDays: json['durationDays'] as int,
      isFeatured: json['isFeatured'] as bool,
      features: List<String>.from(json['features'] ?? []),
      activePromotion: json['activePromotion'] != null
          ? ActivePromotionModel.fromJson(
              json['activePromotion'] as Map<String, dynamic>,
            )
          : null,
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
      activePromotion: activePromotion?.toEntity(),
    );
  }
}