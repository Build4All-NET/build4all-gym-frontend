import '../entities/coupon_validation_entity.dart';
import '../entities/my_membership_entity.dart';
import '../entities/plan_detail_entity.dart';
import '../entities/plan_entity.dart';

abstract class MemberPlansRepository {
  Future<List<PlanEntity>> getActivePlans();

  Future<PlanDetailEntity> getPlanDetail(int planId);

  Future<MyMembershipEntity?> getMyMembership();

  Future<CouponValidationEntity> validateCoupon(
    String couponCode,
    int planId,
  );
}