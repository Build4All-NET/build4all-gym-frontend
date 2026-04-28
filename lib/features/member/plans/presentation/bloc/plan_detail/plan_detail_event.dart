abstract class PlanDetailEvent {}

/// fired on screen init with planId from navigation
class LoadPlanDetailEvent extends PlanDetailEvent {
  final int planId;

  LoadPlanDetailEvent({
    required this.planId,
  });
}

/// fired when user taps apply coupon
class ApplyCouponEvent extends PlanDetailEvent {
  final String couponCode;
  final int planId;

  ApplyCouponEvent({
    required this.couponCode,
    required this.planId,
  });
}

/// fired when user clears coupon field
class ClearCouponEvent extends PlanDetailEvent {}