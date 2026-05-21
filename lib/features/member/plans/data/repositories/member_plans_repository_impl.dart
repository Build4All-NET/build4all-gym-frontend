import '../../domain/entities/checkout_result_entity.dart';
import '../../domain/entities/coupon_validation_entity.dart';
import '../../domain/entities/my_membership_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/plan_detail_entity.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/member_plans_repository.dart';
import '../services/member_plans_remote_datasource.dart';

class MemberPlansRepositoryImpl implements MemberPlansRepository {
  final MemberPlansRemoteDatasource remoteDatasource;

  MemberPlansRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<PlanEntity>> getActivePlans() async {
    final models = await remoteDatasource.getActivePlans();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PlanDetailEntity> getPlanDetail(int planId) async {
    final model = await remoteDatasource.getPlanDetail(planId);

    return model.toEntity();
  }

  @override
  Future<MyMembershipEntity> getMyMembership() async {
    final model = await remoteDatasource.getMyMembership();

    return model.toEntity();
  }

  @override
  Future<CouponValidationEntity> validateCoupon(
    String couponCode,
    int planId,
  ) async {
    final model = await remoteDatasource.validateCoupon(couponCode, planId);
    return model.toEntity();
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    final models = await remoteDatasource.getPaymentMethods();
    return models
        .map((m) => PaymentMethodEntity(
              id: m.id,
              name: m.name,
              displayName: m.displayName,
            ))
        .toList();
  }

  @override
  Future<CheckoutResultEntity> checkout({
    required int planId,
    required String paymentMethod,
    String? couponCode,
  }) async {
    final model = await remoteDatasource.checkout(
      planId: planId,
      paymentMethod: paymentMethod,
      couponCode: couponCode,
    );
    return CheckoutResultEntity(
      membershipId:    model.membershipId,
      invoiceId:       model.invoiceId,
      invoiceNumber:   model.invoiceNumber,
      planName:        model.planName,
      startDate:       model.startDate,
      endDate:         model.endDate,
      originalPrice:   model.originalPrice,
      discountAmount:  model.discountAmount,
      totalAmount:     model.totalAmount,
      membershipStatus: model.membershipStatus,
      paymentStatus:   model.paymentStatus,
      transactionId:   model.transactionId,
      redirectUrl:     model.redirectUrl,
      clientSecret:    model.clientSecret,
      publishableKey:  model.publishableKey,
    );
  }

  @override
  Future<Map<String, String>> confirmStripePayment({
    required int transactionId,
    required int invoiceId,
  }) =>
      remoteDatasource.confirmStripePayment(
          transactionId: transactionId, invoiceId: invoiceId);

  @override
  Future<Map<String, String>> checkPaymentStatus({required int membershipId}) =>
      remoteDatasource.checkPaymentStatus(membershipId: membershipId);
}