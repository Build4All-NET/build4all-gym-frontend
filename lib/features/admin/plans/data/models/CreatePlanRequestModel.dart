import 'plan_feature_model.dart';
import 'plan_promotion_model.dart';

class CreatePlanRequestModel {
  final String name;
  final String planType;
  final double price;
  final String billingCycle;
  final String? description;
  final String status;
  final List<int> branchIds;
  final int? allowedVisits;
  final int? freezeDaysAllowance;
  final int? maxFreezesCount;
  final bool autoRenew;
  final bool isFeatured;
  final int? gracePeriodDays;
  final PlanPromotionModel? promotion;
  final List<PlanFeatureModel> features;

  const CreatePlanRequestModel({
    required this.name,
    required this.planType,
    required this.price,
    required this.billingCycle,
    this.description,
    required this.status,
    required this.branchIds,
    this.allowedVisits,
    this.freezeDaysAllowance,
    this.maxFreezesCount,
    this.autoRenew = false,
    this.isFeatured = false,
    this.gracePeriodDays,
    this.promotion,
    this.features = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'planType': planType,
      'price': price,
      'billingCycle': billingCycle,
      if (description != null) 'description': description,
      'status': status,
      'branchIds': branchIds,
      if (allowedVisits != null) 'allowedVisits': allowedVisits,
      if (freezeDaysAllowance != null)
        'freezeDaysAllowance': freezeDaysAllowance,
      if (maxFreezesCount != null) 'maxFreezesCount': maxFreezesCount,
      'autoRenew': autoRenew,
      'isFeatured': isFeatured,
      if (gracePeriodDays != null) 'gracePeriodDays': gracePeriodDays,
      if (promotion != null) 'promotion': promotion!.toJson(),
      if (features.isNotEmpty)
        'features': features.map((f) => f.toJson()).toList(),
    };
  }
}
