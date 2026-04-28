import '../../domain/entities/admin_plan_list_item_entity.dart';

class AdminPlanListItemModel {
  final int planId;
  final String name;
  final String planType;
  final bool isActive;
  final String? promotionText;
  final String? description;
  final double price;
  final String billingCycle;
  final int memberCount;
  final int? allowedVisits;
  final List<String> branches;

  const AdminPlanListItemModel({
    required this.planId,
    required this.name,
    required this.planType,
    required this.isActive,
    this.promotionText,
    this.description,
    required this.price,
    required this.billingCycle,
    required this.memberCount,
    this.allowedVisits,
    required this.branches,
  });

  factory AdminPlanListItemModel.fromJson(Map<String, dynamic> json) {
    return AdminPlanListItemModel(
      planId: json['planId'] as int,
      name: json['name'] as String,
      planType: json['planType'] as String,
      isActive: json['isActive'] as bool,
      promotionText: json['promotionText'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      billingCycle: json['billingCycle'] as String,
      memberCount: json['memberCount'] as int,
      allowedVisits: json['allowedVisits'] as int?,
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }

  AdminPlanListItemEntity toEntity() => AdminPlanListItemEntity(
    planId: planId,
    name: name,
    planType: planType,
    isActive: isActive,
    promotionText: promotionText,
    description: description,
    price: price,
    billingCycle: billingCycle,
    memberCount: memberCount,
    allowedVisits: allowedVisits,
    branches: branches,
  );
}