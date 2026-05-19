/// Base class for all plan detail events.
///
/// This is full BLoC, not Cubit.
/// The UI sends events, and the BLoC emits states.
abstract class PlanDetailEvent {}

/// Fired when the plan detail screen opens.
///
/// The planId comes from navigation.
class LoadPlanDetailEvent extends PlanDetailEvent {
  final int planId;

  LoadPlanDetailEvent({
    required this.planId,
  });
}

/// Fired when the user taps "تطبيق" after typing a coupon code.
class ApplyCouponEvent extends PlanDetailEvent {
  final String couponCode;
  final int planId;

  ApplyCouponEvent({
    required this.couponCode,
    required this.planId,
  });
}

/// Fired when the user clears the coupon field.
class ClearCouponEvent extends PlanDetailEvent {}

/// Fired once the plan is loaded — loads available payment methods from backend.
class LoadPaymentMethodsEvent extends PlanDetailEvent {}

/// Fired when the member taps a payment method radio button.
class SelectPaymentMethodEvent extends PlanDetailEvent {
  final String methodName;
  SelectPaymentMethodEvent({required this.methodName});
}

/// Fired when the member taps the checkout button.
class SubmitCheckoutEvent extends PlanDetailEvent {
  final int planId;
  final String paymentMethod;
  final String? couponCode;
  SubmitCheckoutEvent({
    required this.planId,
    required this.paymentMethod,
    this.couponCode,
  });
}