import '../../domain/entities/plan_feature_entity.dart';

class PlanFeatureModel {
  final int? featureId;
  final String featureName;
  final String? featureValue;
  final int sortOrder;

  const PlanFeatureModel({
    this.featureId,
    required this.featureName,
    this.featureValue,
    this.sortOrder = 0,
  });

  factory PlanFeatureModel.fromJson(Map<String, dynamic> json) {
    return PlanFeatureModel(
      featureId: json['featureId'] as int?,
      featureName: json['featureName'] as String,
      featureValue: json['featureValue'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (featureId != null) 'featureId': featureId,
        'featureName': featureName,
        if (featureValue != null) 'featureValue': featureValue,
        'sortOrder': sortOrder,
      };

  PlanFeatureEntity toEntity() => PlanFeatureEntity(
        featureId: featureId,
        featureName: featureName,
        featureValue: featureValue,
        sortOrder: sortOrder,
      );
}
