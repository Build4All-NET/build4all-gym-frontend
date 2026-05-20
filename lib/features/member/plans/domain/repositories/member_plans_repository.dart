import '../entities/checkout_result_entity.dart';
import '../entities/coupon_validation_entity.dart';
import '../entities/my_membership_entity.dart';
import '../entities/payment_method_entity.dart';
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

  Future<List<PaymentMethodEntity>> getPaymentMethods();

  Future<CheckoutResultEntity> checkout({
    required int planId,
    required String paymentMethod,
    String? couponCode,
  });

  Future<Map<String, String>> confirmStripePayment({
    required int transactionId,
    required int invoiceId,
  });

  Future<Map<String, String>> checkPaymentStatus({required int membershipId});
}