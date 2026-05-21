import 'plan_entity.dart';

class PlanDetailEntity {
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
  final ActivePromotionEntity? activePromotion;

  const PlanDetailEntity({
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
}