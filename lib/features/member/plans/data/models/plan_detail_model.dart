import '../../domain/entities/plan_detail_entity.dart';
import 'plan_list_item_model.dart';

class PlanDetailModel {
  final int planId;
  final String name;
  final String planType;
  final double price;
  final String billingCycle;
  final int durationDays;
  final bool isFeatured;
  final bool isBooked;
  final String? description;
  final int? allowedVisits;
  final int? freezeDaysAllowance;
  final int? gracePeriodDays;
  final bool autoRenew;
  final List<String> features;
  final ActivePromotionModel? activePromotion;

  PlanDetailModel({
    required this.planId,
    required this.name,
    required this.planType,
    required this.price,
    required this.billingCycle,
    required this.durationDays,
    required this.isFeatured,
    required this.isBooked,
    this.description,
    this.allowedVisits,
    this.freezeDaysAllowance,
    this.gracePeriodDays,
    required this.autoRenew,
    required this.features,
    this.activePromotion,
  });

  factory PlanDetailModel.fromJson(Map<String, dynamic> json) {
    return PlanDetailModel(
      planId: json['planId'] as int,
      name: json['name'] as String? ?? '',
      planType: json['planType'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      billingCycle: json['billingCycle'] as String? ?? '',
      durationDays: json['durationDays'] as int? ?? 0,
      isFeatured: json['isFeatured'] == true,
      isBooked: json['isBooked'] == true,
      description: json['description'] as String?,
      allowedVisits: json['allowedVisits'] as int?,
      freezeDaysAllowance: json['freezeDaysAllowance'] as int?,
      gracePeriodDays: json['gracePeriodDays'] as int?,
      autoRenew: json['autoRenew'] == true,
      features: List<String>.from(json['features'] ?? []),
      activePromotion: json['activePromotion'] != null
          ? ActivePromotionModel.fromJson(
        json['activePromotion'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  PlanDetailEntity toEntity() {
    return PlanDetailEntity(
      planId: planId,
      name: name,
      planType: planType,
      price: price,
      billingCycle: billingCycle,
      durationDays: durationDays,
      isFeatured: isFeatured,
      isBooked: isBooked,
      description: description,
      allowedVisits: allowedVisits,
      freezeDaysAllowance: freezeDaysAllowance,
      gracePeriodDays: gracePeriodDays,
      autoRenew: autoRenew,
      features: features,
      activePromotion: activePromotion?.toEntity(),
    );
  }
}