import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/check_payment_status_usecase.dart';
import '../../../domain/usecases/checkout_usecase.dart';
import '../../../domain/usecases/confirm_stripe_payment_usecase.dart';
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
  final ConfirmStripePaymentUseCase confirmStripePayment;
  final CheckPaymentStatusUseCase checkPaymentStatus;

  PlanDetailBloc({
    required this.getPlanDetail,
    required this.validateCoupon,
    required this.getPaymentMethods,
    required this.checkout,
    required this.confirmStripePayment,
    required this.checkPaymentStatus,
  }) : super(PlanDetailInitial()) {
    on<LoadPlanDetailEvent>(_onLoadPlanDetail);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ClearCouponEvent>(_onClearCoupon);
    on<LoadPaymentMethodsEvent>(_onLoadPaymentMethods);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<SubmitCheckoutEvent>(_onSubmitCheckout);
    on<ConfirmStripePaymentEvent>(_onConfirmStripePayment);
    on<CheckRedirectPaymentEvent>(_onCheckRedirectPayment);
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

      // CASH: membership stays pending → show waiting sheet (existing behaviour)
      if (!result.isStripe && !result.isRedirect) {
        emit(PlanDetailCheckoutSuccess(result: result));
        return;
      }

      // STRIPE / PAYPAL / MPGS: hand off to the screen for gateway UI
      emit(PlanDetailOnlinePaymentReady(
        previousState: current.copyWith(isSubmitting: false),
        result: result,
      ));
    } catch (e) {
      emit(PlanDetailCheckoutError(
        previousState: current.copyWith(isSubmitting: false),
        message: e.toString(),
      ));
    }
  }

  Future<void> _onConfirmStripePayment(
    ConfirmStripePaymentEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    emit(event.previousState.copyWith(isSubmitting: true));
    try {
      final status = await confirmStripePayment(
        transactionId: event.pendingResult.transactionId!,
        invoiceId:     event.pendingResult.invoiceId,
      );
      emit(PlanDetailCheckoutSuccess(
        result: event.pendingResult.copyWithStatus(
          status['membershipStatus'] ?? 'active',
          status['paymentStatus']    ?? 'paid',
        ),
      ));
    } catch (e) {
      emit(PlanDetailCheckoutError(
        previousState: event.previousState.copyWith(isSubmitting: false),
        message: e.toString(),
      ));
    }
  }

  Future<void> _onCheckRedirectPayment(
    CheckRedirectPaymentEvent event,
    Emitter<PlanDetailState> emit,
  ) async {
    emit(event.previousState.copyWith(isSubmitting: true));
    try {
      final status = await checkPaymentStatus(
        membershipId: event.pendingResult.membershipId,
      );
      final ms = status['membershipStatus'] ?? 'pending';
      if (ms.toLowerCase() == 'active') {
        emit(PlanDetailCheckoutSuccess(
          result: event.pendingResult.copyWithStatus(
            ms,
            status['paymentStatus'] ?? 'paid',
          ),
        ));
      } else {
        emit(PlanDetailCheckoutError(
          previousState: event.previousState.copyWith(isSubmitting: false),
          message: event.paymentNotConfirmedMessage,
        ));
      }
    } catch (e) {
      emit(PlanDetailCheckoutError(
        previousState: event.previousState.copyWith(isSubmitting: false),
        message: e.toString(),
      ));
    }
  }
}
