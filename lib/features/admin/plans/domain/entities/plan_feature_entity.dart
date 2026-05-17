class PlanFeatureEntity {
  final int? featureId;
  final String featureName;
  final String? featureValue;
  final int sortOrder;

  const PlanFeatureEntity({
    this.featureId,
    required this.featureName,
    this.featureValue,
    this.sortOrder = 0,
  });
}
