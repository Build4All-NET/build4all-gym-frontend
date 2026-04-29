import '../entities/coupon_validation_entity.dart';
import '../repositories/member_plans_repository.dart';

class ValidateCouponUseCase {
  final MemberPlansRepository repository;

  ValidateCouponUseCase({required this.repository});

  Future<CouponValidationEntity> call(String couponCode, int planId) {
    return repository.validateCoupon(couponCode, planId);
  }
}