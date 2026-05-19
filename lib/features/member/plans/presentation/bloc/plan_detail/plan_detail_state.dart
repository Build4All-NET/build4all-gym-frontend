import '../../../domain/entities/checkout_result_entity.dart';
import '../../../domain/entities/coupon_validation_entity.dart';
import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/entities/plan_detail_entity.dart';

abstract class PlanDetailState {}

class PlanDetailInitial extends PlanDetailState {}

class PlanDetailLoading extends PlanDetailState {}

class PlanDetailLoaded extends PlanDetailState {
  final PlanDetailEntity plan;
  final CouponValidationEntity? coupon;
  final bool isCouponValidating;
  final List<PaymentMethodEntity> paymentMethods;
  final bool isPaymentMethodsLoading;
  final String? selectedPaymentMethod;
  final bool isSubmitting;

  PlanDetailLoaded({
    required this.plan,
    this.coupon,
    this.isCouponValidating = false,
    this.paymentMethods = const [],
    this.isPaymentMethodsLoading = false,
    this.selectedPaymentMethod,
    this.isSubmitting = false,
  });

  PlanDetailLoaded copyWith({
    CouponValidationEntity? coupon,
    bool? isCouponValidating,
    List<PaymentMethodEntity>? paymentMethods,
    bool? isPaymentMethodsLoading,
    String? selectedPaymentMethod,
    bool? isSubmitting,
    bool clearCoupon = false,
    bool clearSelectedPaymentMethod = false,
  }) {
    return PlanDetailLoaded(
      plan: plan,
      coupon: clearCoupon ? null : (coupon ?? this.coupon),
      isCouponValidating: isCouponValidating ?? this.isCouponValidating,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      isPaymentMethodsLoading:
          isPaymentMethodsLoading ?? this.isPaymentMethodsLoading,
      selectedPaymentMethod: clearSelectedPaymentMethod
          ? null
          : (selectedPaymentMethod ?? this.selectedPaymentMethod),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class PlanDetailError extends PlanDetailState {
  final String message;
  PlanDetailError({required this.message});
}

class PlanDetailCheckoutSuccess extends PlanDetailState {
  final CheckoutResultEntity result;
  PlanDetailCheckoutSuccess({required this.result});
}

class PlanDetailCheckoutError extends PlanDetailState {
  final PlanDetailLoaded previousState;
  final String message;
  PlanDetailCheckoutError({required this.previousState, required this.message});
}
