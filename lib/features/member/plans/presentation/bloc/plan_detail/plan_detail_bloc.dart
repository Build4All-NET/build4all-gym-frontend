import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_plan_detail_usecase.dart';
import '../../../domain/usecases/validate_coupon_usecase.dart';
import 'plan_detail_event.dart';
import 'plan_detail_state.dart';

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

  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    final currentState = state;

    if (currentState is! PlanDetailLoaded) return;

    /// show loading spinner only on coupon button
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
        ),
      );
    } catch (e) {
      emit(
        PlanDetailLoaded(
          plan: currentState.plan,
        ),
      );
    }
  }

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
        ),
      );
    }
  }
}