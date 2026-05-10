import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_plan_detail_usecase.dart';
import '../../../domain/usecases/validate_coupon_usecase.dart';
import 'plan_detail_event.dart';
import 'plan_detail_state.dart';

/// BLoC responsible for the plan detail screen.
///
/// It handles:
/// - loading the selected plan details
/// - validating coupon codes
/// - clearing an applied coupon
///
/// This BLoC only calls domain usecases.
/// It does not access datasource or repository directly.
class PlanDetailBloc extends Bloc<PlanDetailEvent, PlanDetailState> {
  final GetPlanDetailUseCase getPlanDetail;
  final ValidateCouponUseCase validateCoupon;

  PlanDetailBloc({
    required this.getPlanDetail,
    required this.validateCoupon,
  }) : super(PlanDetailInitial()) {
    on<LoadPlanDetailEvent>(_onLoadPlanDetail);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ClearCouponEvent>(_onClearCoupon);
  }

  /// Handles loading the selected plan.
  ///
  /// Flow:
  /// 1. Emit loading state
  /// 2. Call GetPlanDetailUseCase with planId
  /// 3. Emit loaded state if successful
  /// 4. Emit error state if something fails
  Future<void> _onLoadPlanDetail(
      LoadPlanDetailEvent event,
      Emitter<PlanDetailState> emit,
      ) async {
    emit(PlanDetailLoading());

    try {
      final plan = await getPlanDetail(event.planId);

      emit(
        PlanDetailLoaded(
          plan: plan,
        ),
      );
    } catch (e) {
      emit(
        PlanDetailError(
          message: e.toString(),
        ),
      );
    }
  }

  /// Handles coupon validation.
  ///
  /// This does not reload the plan.
  /// It only updates the coupon part of the loaded state.
  Future<void> _onApplyCoupon(
      ApplyCouponEvent event,
      Emitter<PlanDetailState> emit,
      ) async {
    final currentState = state;

    if (currentState is! PlanDetailLoaded) return;

    // Show spinner only on the coupon button while validating.
    emit(
      PlanDetailLoaded(
        plan: currentState.plan,
        coupon: currentState.coupon,
        isCouponValidating: true,
      ),
    );

    try {
      final result = await validateCoupon(
        event.couponCode,
        event.planId,
      );

      emit(
        PlanDetailLoaded(
          plan: currentState.plan,
          coupon: result,
          isCouponValidating: false,
        ),
      );
    } catch (e) {
      // Keep the plan visible even if coupon validation fails.
      emit(
        PlanDetailLoaded(
          plan: currentState.plan,
          coupon: null,
          isCouponValidating: false,
        ),
      );
    }
  }

  /// Handles clearing the coupon field.
  ///
  /// Removes coupon data while keeping the plan details visible.
  void _onClearCoupon(
      ClearCouponEvent event,
      Emitter<PlanDetailState> emit,
      ) {
    final currentState = state;

    if (currentState is PlanDetailLoaded) {
      emit(
        PlanDetailLoaded(
          plan: currentState.plan,
          coupon: null,
          isCouponValidating: false,
        ),
      );
    }
  }
}