import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/checkout_usecase.dart';
import '../../../domain/usecases/get_payment_methods_usecase.dart';
import '../../../domain/usecases/get_plan_detail_usecase.dart';
import '../../../domain/usecases/validate_coupon_usecase.dart';
import 'plan_detail_event.dart';
import 'plan_detail_state.dart';

class PlanDetailBloc extends Bloc<PlanDetailEvent, PlanDetailState> {
  final GetPlanDetailUseCase getPlanDetail;
  final ValidateCouponUseCase validateCoupon;
  final GetPaymentMethodsUseCase getPaymentMethods;
  final CheckoutUseCase checkout;

  PlanDetailBloc({
    required this.getPlanDetail,
    required this.validateCoupon,
    required this.getPaymentMethods,
    required this.checkout,
  }) : super(PlanDetailInitial()) {
    on<LoadPlanDetailEvent>(_onLoadPlanDetail);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ClearCouponEvent>(_onClearCoupon);
    on<LoadPaymentMethodsEvent>(_onLoadPaymentMethods);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<SubmitCheckoutEvent>(_onSubmitCheckout);
  }

  Future<void> _onLoadPlanDetail(
    LoadPlanDetailEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    emit(PlanDetailLoading());
    try {
      final plan = await getPlanDetail(event.planId);
      emit(PlanDetailLoaded(plan: plan, isPaymentMethodsLoading: true));
      add(LoadPaymentMethodsEvent());
    } catch (e) {
      emit(PlanDetailError(message: e.toString()));
    }
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethodsEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    final current = state;
    if (current is! PlanDetailLoaded) return;

    try {
      final methods = await getPaymentMethods();
      final firstMethod = methods.isNotEmpty ? methods.first.name : null;
      emit(current.copyWith(
        paymentMethods: methods,
        isPaymentMethodsLoading: false,
        selectedPaymentMethod: firstMethod,
      ));
    } catch (_) {
      emit(current.copyWith(isPaymentMethodsLoading: false));
    }
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<PlanDetailState> emit,
  ) {
    final current = state;
    if (current is! PlanDetailLoaded) return;
    emit(current.copyWith(selectedPaymentMethod: event.methodName));
  }

  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    final current = state;
    if (current is! PlanDetailLoaded) return;

    emit(current.copyWith(isCouponValidating: true));
    try {
      final result = await validateCoupon(event.couponCode, event.planId);
      emit(current.copyWith(coupon: result, isCouponValidating: false));
    } catch (_) {
      emit(current.copyWith(clearCoupon: true, isCouponValidating: false));
    }
  }

  void _onClearCoupon(ClearCouponEvent event, Emitter<PlanDetailState> emit) {
    final current = state;
    if (current is PlanDetailLoaded) {
      emit(current.copyWith(clearCoupon: true));
    }
  }

  Future<void> _onSubmitCheckout(
    SubmitCheckoutEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    final current = state;
    if (current is! PlanDetailLoaded) return;

    emit(current.copyWith(isSubmitting: true));
    try {
      final result = await checkout(
        planId: event.planId,
        paymentMethod: event.paymentMethod,
        couponCode: event.couponCode,
      );
      emit(PlanDetailCheckoutSuccess(result: result));
    } catch (e) {
      emit(PlanDetailCheckoutError(
        previousState: current.copyWith(isSubmitting: false),
        message: e.toString(),
      ));
    }
  }
}
