import 'plan_feature_model.dart';
import 'plan_promotion_model.dart';

// All fields nullable — only non-null fields are updated (partial update).
// promotion == null      → don't touch promotions
// promotion.title blank  → deactivate all active promotions
// promotion.title set    → create or update active promotion
// features == null       → don't touch features
// features == []         → delete all features
// features non-empty     → replace all features
class UpdatePlanRequestModel {
  final String? name;
  final String? planType;
  final double? price;
  final String? billingCycle;
  final int? customDurationDays;
  final String? description;
  final String? status;
  final List<int>? branchIds;
  final int? allowedVisits;
  final int? freezeDaysAllowance;
  final int? maxFreezesCount;
  final bool? autoRenew;
  final bool? isFeatured;
  final int? gracePeriodDays;
  final String? gymAccessStart;
  final String? gymAccessEnd;
  final PlanPromotionModel? promotion;
  final List<PlanFeatureModel>? features;

  const UpdatePlanRequestModel({
    this.name,
    this.planType,
    this.price,
    this.billingCycle,
    this.customDurationDays,
    this.description,
    this.status,
    this.branchIds,
    this.allowedVisits,
    this.freezeDaysAllowance,
    this.maxFreezesCount,
    this.autoRenew,
    this.isFeatured,
    this.gracePeriodDays,
    this.gymAccessStart,
    this.gymAccessEnd,
    this.promotion,
    this.features,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (planType != null) map['planType'] = planType;
    if (price != null) map['price'] = price;
    if (billingCycle != null) map['billingCycle'] = billingCycle;
    if (customDurationDays != null) map['customDurationDays'] = customDurationDays;
    if (description != null) map['description'] = description;
    if (status != null) map['status'] = status;
    if (branchIds != null) map['branchIds'] = branchIds;
    if (allowedVisits != null) map['allowedVisits'] = allowedVisits;
    if (freezeDaysAllowance != null)
      map['freezeDaysAllowance'] = freezeDaysAllowance;
    if (maxFreezesCount != null) map['maxFreezesCount'] = maxFreezesCount;
    if (autoRenew != null) map['autoRenew'] = autoRenew;
    if (isFeatured != null) map['isFeatured'] = isFeatured;
    if (gracePeriodDays != null) map['gracePeriodDays'] = gracePeriodDays;
    if (gymAccessStart != null) map['gymAccessStart'] = gymAccessStart;
    if (gymAccessEnd != null) map['gymAccessEnd'] = gymAccessEnd;
    if (promotion != null) map['promotion'] = promotion!.toJson();
    if (features != null)
      map['features'] = features!.map((f) => f.toJson()).toList();
    return map;
  }
}
