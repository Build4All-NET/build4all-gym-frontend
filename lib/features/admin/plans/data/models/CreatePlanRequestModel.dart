class CreatePlanRequestModel {
  final String name;
  final String planType;
  final double price;
  final String billingCycle; // monthly / quarterly / yearly / one_time
  final String? description;
  final String? promotionText;
  final String status; // "active" or "inactive"
  final List<int> branchIds;
  final int? allowedVisits; // null = Unlimited
  final int? freezeDaysAllowance;

  const CreatePlanRequestModel({
    required this.name,
    required this.planType,
    required this.price,
    required this.billingCycle,
    this.description,
    this.promotionText,
    required this.status,
    required this.branchIds,
    this.allowedVisits,
    this.freezeDaysAllowance,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'planType': planType,
      'price': price,
      'billingCycle': billingCycle,
      if (description != null) 'description': description,
      if (promotionText != null) 'promotionText': promotionText,
      'status': status,
      'branchIds': branchIds,
      if (allowedVisits != null) 'allowedVisits': allowedVisits,
      if (freezeDaysAllowance != null)
        'freezeDaysAllowance': freezeDaysAllowance,
    };
  }
}