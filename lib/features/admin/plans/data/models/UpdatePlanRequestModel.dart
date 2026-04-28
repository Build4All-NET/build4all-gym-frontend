class UpdatePlanRequestModel {
  final String? name;
  final String? planType;
  final double? price;
  final String? billingCycle;
  final String? description;
  // null = don't touch promotions
  // ""   = deactivate all promotions
  // text = set/update promotion
  final String? promotionText;
  final String? status;
  final List<int>? branchIds; // if provided, replaces ALL current assignments
  final int? allowedVisits;
  final int? freezeDaysAllowance;

  const UpdatePlanRequestModel({
    this.name,
    this.planType,
    this.price,
    this.billingCycle,
    this.description,
    this.promotionText,
    this.status,
    this.branchIds,
    this.allowedVisits,
    this.freezeDaysAllowance,
  });

  // Only include non-null fields — backend does partial update
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (planType != null) map['planType'] = planType;
    if (price != null) map['price'] = price;
    if (billingCycle != null) map['billingCycle'] = billingCycle;
    if (description != null) map['description'] = description;
    if (promotionText != null) map['promotionText'] = promotionText;
    if (status != null) map['status'] = status;
    if (branchIds != null) map['branchIds'] = branchIds;
    if (allowedVisits != null) map['allowedVisits'] = allowedVisits;
    if (freezeDaysAllowance != null) {
      map['freezeDaysAllowance'] = freezeDaysAllowance;
    }
    return map;
  }
}