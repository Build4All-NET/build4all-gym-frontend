import '../../../domain/entities/coupon_validation_entity.dart';
import '../../../domain/entities/plan_detail_entity.dart';

abstract class PlanDetailState {}

class PlanDetailInitial extends PlanDetailState {}

class PlanDetailLoading extends PlanDetailState {}

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

class PlanDetailError extends PlanDetailState {
  final String message;

  PlanDetailError({
    required this.message,
  });
}