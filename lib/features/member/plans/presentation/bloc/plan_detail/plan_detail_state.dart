import '../../../domain/entities/coupon_validation_entity.dart';
import '../../../domain/entities/plan_detail_entity.dart';

/// Base class for all plan detail states.
abstract class PlanDetailState {}

/// Initial state before anything happens.
class PlanDetailInitial extends PlanDetailState {}

/// Loading state while the plan details are being fetched.
class PlanDetailLoading extends PlanDetailState {}

/// Success state when the plan details are loaded.
///
/// coupon = null means no coupon has been applied yet.
/// isCouponValidating = true means show spinner only on the coupon button.
class PlanDetailLoaded extends PlanDetailState {
  final PlanDetailEntity plan;
  final CouponValidationEntity? coupon;
  final bool isCouponValidating;

  PlanDetailLoaded({
    required this.plan,
    this.coupon,
    this.isCouponValidating = false,
  });
}

/// Error state when loading the plan detail fails.
class PlanDetailError extends PlanDetailState {
  final String message;

  PlanDetailError({
    required this.message,
  });
}