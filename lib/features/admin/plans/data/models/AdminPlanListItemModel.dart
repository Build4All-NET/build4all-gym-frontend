import '../../domain/entities/admin_plan_list_item_entity.dart';
import 'plan_feature_model.dart';
import 'plan_promotion_model.dart';

class AdminPlanListItemModel {
  final int planId;
  final String name;
  final String planType;
  final bool isActive;
  final bool isFeatured;
  final bool autoRenew;
  final String? description;
  final double price;
  final String billingCycle;
  final int? durationDays;
  final int memberCount;
  final int? allowedVisits;
  final int? freezeDaysAllowance;
  final int? maxFreezesCount;
  final int? gracePeriodDays;
  final String? gymAccessStart;
  final String? gymAccessEnd;
  final List<String> branches;
  final List<int> branchIds;
  final String? promotionText;
  final PlanPromotionModel? promotion;
  final List<PlanFeatureModel> features;

  const AdminPlanListItemModel({
    required this.planId,
    required this.name,
    required this.planType,
    required this.isActive,
    this.isFeatured = false,
    this.autoRenew = false,
    this.description,
    required this.price,
    required this.billingCycle,
    this.durationDays,
    required this.memberCount,
    this.allowedVisits,
    this.freezeDaysAllowance,
    this.maxFreezesCount,
    this.gracePeriodDays,
    this.gymAccessStart,
    this.gymAccessEnd,
    required this.branches,
    this.branchIds = const <int>[],
    this.promotionText,
    this.promotion,
    this.features = const [],
  });

  factory AdminPlanListItemModel.fromJson(Map<String, dynamic> json) {
    return AdminPlanListItemModel(
      planId: json['planId'] as int,
      name: json['name'] as String,
      planType: json['planType'] as String,
      isActive: json['isActive'] as bool,
      isFeatured: json['isFeatured'] as bool? ?? false,
      autoRenew: json['autoRenew'] as bool? ?? false,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      billingCycle: json['billingCycle'] as String,
      durationDays: json['durationDays'] as int?,
      memberCount: json['memberCount'] as int,
      allowedVisits: json['allowedVisits'] as int?,
      freezeDaysAllowance: json['freezeDaysAllowance'] as int?,
      maxFreezesCount: json['maxFreezesCount'] as int?,
      gracePeriodDays: json['gracePeriodDays'] as int?,
      gymAccessStart: json['gymAccessStart'] as String?,
      gymAccessEnd: json['gymAccessEnd'] as String?,
      branches: (json['branches'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      branchIds: (json['branchIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      promotionText: json['promotionText'] as String?,
      promotion: json['promotion'] != null
          ? PlanPromotionModel.fromJson(
              json['promotion'] as Map<String, dynamic>)
          : null,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) =>
                  PlanFeatureModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  AdminPlanListItemEntity toEntity() => AdminPlanListItemEntity(
        planId: planId,
        name: name,
        planType: planType,
        isActive: isActive,
        isFeatured: isFeatured,
        autoRenew: autoRenew,
        description: description,
        price: price,
        billingCycle: billingCycle,
        durationDays: durationDays,
        memberCount: memberCount,
        allowedVisits: allowedVisits,
        freezeDaysAllowance: freezeDaysAllowance,
        maxFreezesCount: maxFreezesCount,
        gracePeriodDays: gracePeriodDays,
        gymAccessStart: gymAccessStart,
        gymAccessEnd: gymAccessEnd,
        branches: branches,
        branchIds: branchIds,
        promotionText: promotionText,
        promotion: promotion?.toEntity(),
        features: features.map((f) => f.toEntity()).toList(),
      );
}
