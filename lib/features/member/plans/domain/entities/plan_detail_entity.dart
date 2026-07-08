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
  final String bookingStatus;

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
    required this.bookingStatus,
    this.description,
    this.allowedVisits,
    this.freezeDaysAllowance,
    this.gracePeriodDays,
    required this.autoRenew,
    required this.features,
    this.activePromotion,
  });

  bool get isPending => bookingStatus.toUpperCase() == 'PENDING';
  bool get isActiveBooked => bookingStatus.toUpperCase() == 'BOOKED';
  bool get canSelect => bookingStatus.toUpperCase() == 'NONE';

  double get displayPrice => activePromotion?.finalPrice ?? price;
  bool get hasActivePromotion => activePromotion != null;
}