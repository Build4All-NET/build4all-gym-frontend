import '../../domain/entities/coupon_validation_entity.dart';

class CouponValidationResponseModel {
  final bool valid;
  final String? discountType;
  final double? discountValue;
  final double? originalPrice;
  final double? finalPrice;
  final String message;

  CouponValidationResponseModel({
    required this.valid,
    this.discountType,
    this.discountValue,
    this.originalPrice,
    this.finalPrice,
    required this.message,
  });

  factory CouponValidationResponseModel.fromJson(Map<String, dynamic> json) {
    return CouponValidationResponseModel(
      valid: json['valid'] as bool,
      discountType: json['discountType'] as String?,
      discountValue: json['discountValue'] != null
          ? (json['discountValue'] as num).toDouble()
          : null,
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      finalPrice: json['finalPrice'] != null
          ? (json['finalPrice'] as num).toDouble()
          : null,
      message: json['message'] as String,
    );
  }

  CouponValidationEntity toEntity() {
    return CouponValidationEntity(
      valid: valid,
      discountType: discountType,
      discountValue: discountValue,
      originalPrice: originalPrice,
      finalPrice: finalPrice,
      message: message,
    );
  }
}