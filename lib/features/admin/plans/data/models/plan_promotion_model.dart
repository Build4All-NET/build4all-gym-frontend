import '../../domain/entities/plan_promotion_entity.dart';

class PlanPromotionModel {
  final int? promotionId;
  final String? title;
  final String? description;
  final String? discountType; // "fixed" or "percentage"
  final double? discountValue;
  final String? startDate; // ISO date string "yyyy-MM-dd"
  final String? endDate;
  final bool? isActive;

  const PlanPromotionModel({
    this.promotionId,
    this.title,
    this.description,
    this.discountType,
    this.discountValue,
    this.startDate,
    this.endDate,
    this.isActive,
  });

  factory PlanPromotionModel.fromJson(Map<String, dynamic> json) {
    return PlanPromotionModel(
      promotionId: json['promotionId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      discountType: json['discountType'] as String?,
      discountValue: json['discountValue'] != null
          ? (json['discountValue'] as num).toDouble()
          : null,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (promotionId != null) 'promotionId': promotionId,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (discountType != null) 'discountType': discountType,
        if (discountValue != null) 'discountValue': discountValue,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };

  PlanPromotionEntity? toEntity() {
    if (title == null || title!.isEmpty) return null;
    return PlanPromotionEntity(
      promotionId: promotionId,
      title: title!,
      description: description,
      discountType: discountType ?? 'fixed',
      discountValue: discountValue ?? 0.0,
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      endDate: endDate != null ? DateTime.tryParse(endDate!) : null,
      isActive: isActive ?? true,
    );
  }
}
