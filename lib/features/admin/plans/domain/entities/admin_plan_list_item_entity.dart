import 'plan_feature_entity.dart';
import 'plan_promotion_entity.dart';

class AdminPlanListItemEntity {
  final int planId;
  final String name;
  final String planType;
  final bool isActive;
  final bool isFeatured;
  final bool autoRenew;
  final String? description;
  final double price;
  final String billingCycle;
  final int memberCount;
  final int? allowedVisits;
  final int? freezeDaysAllowance;
  final int? maxFreezesCount;
  final int? gracePeriodDays;
  final String? gymAccessStart;
  final String? gymAccessEnd;
  final List<String> branches;
  final List<int> branchIds;

  // Quick display label from active promotion title
  final String? promotionText;
  // Full active promotion for edit pre-population
  final PlanPromotionEntity? promotion;
  // All plan features ordered by sort_order
  final List<PlanFeatureEntity> features;

  const AdminPlanListItemEntity({
    required this.planId,
    required this.name,
    required this.planType,
    required this.isActive,
    this.isFeatured = false,
    this.autoRenew = false,
    this.description,
    required this.price,
    required this.billingCycle,
    required this.memberCount,
    this.allowedVisits,
    this.freezeDaysAllowance,
    this.maxFreezesCount,
    this.gracePeriodDays,
    this.gymAccessStart,
    this.gymAccessEnd,
    required this.branches,
    this.branchIds = const [],
    this.promotionText,
    this.promotion,
    this.features = const [],
  });
}
