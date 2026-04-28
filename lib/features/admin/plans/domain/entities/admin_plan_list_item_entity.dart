class AdminPlanListItemEntity {
  final int planId;
  final String name;
  final String planType;
  final bool isActive;
  final String? promotionText;
  final String? description;
  final double price;
  final String billingCycle;
  final int memberCount;
  final int? allowedVisits; // null = Unlimited
  final List<String> branches;

  const AdminPlanListItemEntity({
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
}