import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:build4allgym/core/currency/currency_cubit.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../data/repositories/member_plans_repository_impl.dart';
import '../../data/services/member_plans_remote_datasource.dart';
import '../../domain/entities/checkout_result_entity.dart';
import '../../domain/entities/coupon_validation_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/plan_detail_entity.dart';
import '../../domain/usecases/check_payment_status_usecase.dart';
import '../../domain/usecases/checkout_usecase.dart';
import '../../domain/usecases/confirm_stripe_payment_usecase.dart';
import '../../domain/usecases/get_payment_methods_usecase.dart';
import '../../domain/usecases/get_plan_detail_usecase.dart';
import '../../domain/usecases/validate_coupon_usecase.dart';
import '../bloc/plan_detail/plan_detail_bloc.dart';
import '../bloc/plan_detail/plan_detail_event.dart';
import '../bloc/plan_detail/plan_detail_state.dart';

class PlanDetailScreenProvider extends StatelessWidget {
  final int planId;
  final Dio dio;

  const PlanDetailScreenProvider({
    super.key,
    required this.planId,
    required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    final remoteDatasource = MemberPlansRemoteDatasourceImpl(dio: dio);

    final repository = MemberPlansRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );

    return BlocProvider(
      create: (_) => PlanDetailBloc(
        getPlanDetail: GetPlanDetailUseCase(
          repository: repository,
        ),
        validateCoupon: ValidateCouponUseCase(
          repository: repository,
        ),
        getPaymentMethods: GetPaymentMethodsUseCase(
          repository: repository,
        ),
        checkout: CheckoutUseCase(
          repository: repository,
        ),
        confirmStripePayment: ConfirmStripePaymentUseCase(
          repository: repository,
        ),
        checkPaymentStatus: CheckPaymentStatusUseCase(
          repository: repository,
        ),
      )..add(
        LoadPlanDetailEvent(planId: planId),
      ),
      child: PlanDetailScreen(planId: planId),
    );
  }
}

class PlanDetailScreen extends StatefulWidget {
  final int planId;

  const PlanDetailScreen({
    super.key,
    required this.planId,
  });

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<PlanDetailBloc, PlanDetailState>(
      listenWhen: (_, currentState) =>
      currentState is PlanDetailCheckoutSuccess ||
          currentState is PlanDetailCheckoutError ||
          currentState is PlanDetailOnlinePaymentReady,
      listener: (context, state) {
        if (state is PlanDetailCheckoutSuccess) {
          _showCheckoutResult(
            context,
            state.result,
            tokens,
          );
        } else if (state is PlanDetailCheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: tokens.colors.danger,
            ),
          );
        } else if (state is PlanDetailOnlinePaymentReady) {
          _handleOnlinePayment(
            context,
            state,
            tokens,
          );
        }
      },
      builder: (context, state) {
        /*
         * Keep the previous loaded screen visible during temporary states,
         * such as an online payment or a checkout error.
         */
        final PlanDetailState renderState;

        if (state is PlanDetailCheckoutError) {
          renderState = state.previousState;
        } else if (state is PlanDetailOnlinePaymentReady) {
          renderState = state.previousState;
        } else {
          renderState = state;
        }

        if (renderState is PlanDetailLoading) {
          return Scaffold(
            backgroundColor: tokens.colors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: tokens.colors.primary,
              ),
            ),
          );
        }

        if (renderState is PlanDetailError) {
          return Scaffold(
            backgroundColor: tokens.colors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      renderState.message,
                      textAlign: TextAlign.center,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.back),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (renderState is PlanDetailLoaded) {
          final loaded = renderState;
          final plan = loaded.plan;

          // Booking status guard — mirrors the plan_card_widget button logic.
          // plan.bookingStatus comes from the backend as "NONE" | "PENDING" | "BOOKED".
          final isPending = plan.isPending;
          final isAlreadyBooked = plan.isActiveBooked;
          final isCheckoutDisabled =
              loaded.isSubmitting ||
                  loaded.selectedPaymentMethod == null ||
                  isPending ||
                  isAlreadyBooked;

          return Scaffold(
            backgroundColor: tokens.colors.background,
            body: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        tokens.colors.primary,
                        tokens.colors.success.withOpacity(0.88),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(19),
                      bottomRight: Radius.circular(19),
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      18,
                      16,
                      28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeaderTitle(
                          planName: plan.name,
                        ),
                        const SizedBox(height: 28),
                        _CheckoutPlanCard(
                          plan: plan,
                          coupon: loaded.coupon,
                        ),
                        SizedBox(
                          height: tokens.spacing.lg,
                        ),
                        _CouponCard(
                          planId: widget.planId,
                          couponController: _couponController,
                          coupon: loaded.coupon,
                          isCouponValidating:
                          loaded.isCouponValidating,
                        ),
                        SizedBox(
                          height: tokens.spacing.lg,
                        ),
                        _PaymentMethodsCard(
                          methods: loaded.paymentMethods,
                          selectedMethod:
                          loaded.selectedPaymentMethod,
                          isLoading:
                          loaded.isPaymentMethodsLoading,
                          tokens: tokens,
                        ),
                        SizedBox(
                          height: tokens.spacing.xl,
                        ),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isCheckoutDisabled
                                ? null
                                : () {
                              final coupon =
                              loaded.coupon?.valid == true
                                  ? _couponController.text.trim()
                                  : null;

                              context
                                  .read<PlanDetailBloc>()
                                  .add(
                                SubmitCheckoutEvent(
                                  planId: widget.planId,
                                  paymentMethod:
                                  loaded
                                      .selectedPaymentMethod!,
                                  couponCode: coupon,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPending
                                  ? tokens.colors.primary
                                  .withOpacity(0.12)
                                  : isAlreadyBooked
                                  ? tokens.colors.success
                                  .withOpacity(0.14)
                                  : tokens.colors.primary,
                              foregroundColor: isPending
                                  ? tokens.colors.primary
                                  : isAlreadyBooked
                                  ? tokens.colors.success
                                  : tokens.colors.onPrimary,
                              disabledBackgroundColor: isPending
                                  ? tokens.colors.primary
                                  .withOpacity(0.12)
                                  : isAlreadyBooked
                                  ? tokens.colors.success
                                  .withOpacity(0.14)
                                  : tokens.colors.primary
                                  .withOpacity(0.4),
                              disabledForegroundColor: isPending
                                  ? tokens.colors.primary
                                  : isAlreadyBooked
                                  ? tokens.colors.success
                                  : tokens.colors.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                            ),
                            child: loaded.isSubmitting
                                ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: isPending
                                    ? tokens.colors.primary
                                    : isAlreadyBooked
                                    ? tokens.colors.success
                                    : tokens.colors.onPrimary,
                              ),
                            )
                                : Text(
                              isPending
                                  ? l10n.planPendingApproval
                                  : isAlreadyBooked
                                  ? l10n.booked
                                  : l10n.selectThisPlan,
                              style: tokens
                                  .typography.bodyMedium
                                  .copyWith(
                                color: isPending
                                    ? tokens.colors.primary
                                    : isAlreadyBooked
                                    ? tokens.colors.success
                                    : tokens.colors.onPrimary,
                                fontWeight:
                                FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showCheckoutResult(
      BuildContext context,
      CheckoutResultEntity result,
      dynamic tokens,
      ) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) => _CheckoutResultSheet(
        result: result,
        tokens: tokens,
      ),
    );
  }

  void _handleOnlinePayment(
      BuildContext context,
      PlanDetailOnlinePaymentReady state,
      dynamic tokens,
      ) {
    final result = state.result;

    if (result.isStripe) {
      _presentStripeSheet(
        context,
        state,
        tokens,
      );
    } else if (result.isRedirect) {
      _launchRedirectPayment(
        context,
        state,
        tokens,
      );
    }
  }

  Future<void> _presentStripeSheet(
      BuildContext context,
      PlanDetailOnlinePaymentReady state,
      dynamic tokens,
      ) async {
    try {
      Stripe.publishableKey =
      state.result.publishableKey!;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters:
        SetupPaymentSheetParameters(
          paymentIntentClientSecret:
          state.result.clientSecret!,
          merchantDisplayName: 'Build4All Gym',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (context.mounted) {
        context.read<PlanDetailBloc>().add(
          ConfirmStripePaymentEvent(
            previousState: state.previousState,
            pendingResult: state.result,
          ),
        );
      }
    } on StripeException catch (error) {
      if (context.mounted &&
          error.error.code != FailureCode.Canceled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.paymentSheetPaymentFailed,
            ),
            backgroundColor: tokens.colors.danger,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: tokens.colors.danger,
          ),
        );
      }
    }
  }

  Future<void> _launchRedirectPayment(
      BuildContext context,
      PlanDetailOnlinePaymentReady state,
      dynamic tokens,
      ) async {
    final url = Uri.parse(
      state.result.redirectUrl!,
    );

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return _WaitingForRedirectSheet(
          tokens: tokens,
          onDone: () {
            Navigator.of(sheetContext).pop();

            context.read<PlanDetailBloc>().add(
              CheckRedirectPaymentEvent(
                previousState: state.previousState,
                pendingResult: state.result,
              ),
            );
          },
          onRelaunch: () async {
            try {
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            } catch (_) {}
          },
        );
      },
    );
  }
}

class _WaitingForRedirectSheet extends StatelessWidget {
  final dynamic tokens;
  final VoidCallback onDone;
  final VoidCallback onRelaunch;

  const _WaitingForRedirectSheet({
    required this.tokens,
    required this.onDone,
    required this.onRelaunch,
  });

  @override
  Widget build(BuildContext context) {
    final colors = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.open_in_browser_rounded,
              color: colors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.paymentSheetCompleteInBrowserTitle,
            textAlign: TextAlign.center,
            style: tokens.typography.headlineSmall.copyWith(
              color: colors.label,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paymentSheetCompleteInBrowserMessage,
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(
              color: colors.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.paymentSheetDoneVerifyPayment,
                textAlign: TextAlign.center,
                style: tokens.typography.bodyMedium.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRelaunch,
            child: Text(
              l10n.paymentSheetReopenPaymentPage,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  final List<PaymentMethodEntity> methods;
  final String? selectedMethod;
  final bool isLoading;
  final dynamic tokens;

  const _PaymentMethodsCard({
    required this.methods,
    required this.selectedMethod,
    required this.isLoading,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final colors = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: textDirection,
            children: [
              Icon(
                Icons.payment_outlined,
                color: colors.primary,
                size: 22,
              ),
              SizedBox(
                width: tokens.spacing.sm,
              ),
              Expanded(
                child: Text(
                  l10n.memberInvoicesPaymentMethod,
                  textAlign: textAlign,
                  style:
                  tokens.typography.titleMedium.copyWith(
                    color: colors.label,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: tokens.spacing.md,
          ),
          if (isLoading)
            Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
            )
          else if (methods.isEmpty)
            Text(
              l10n.paymentSheetNoMethodsAvailable,
              textAlign: textAlign,
              style:
              tokens.typography.bodyMedium.copyWith(
                color: colors.muted,
              ),
            )
          else
            ...methods.map(
                  (method) => _PaymentMethodRow(
                method: method,
                isSelected:
                selectedMethod == method.name,
                tokens: tokens,
                onTap: () {
                  context.read<PlanDetailBloc>().add(
                    SelectPaymentMethodEvent(
                      methodName: method.name,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  final PaymentMethodEntity method;
  final bool isSelected;
  final dynamic tokens;
  final VoidCallback onTap;

  const _PaymentMethodRow({
    required this.method,
    required this.isSelected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = tokens.colors;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.07)
              : colors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.border.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          textDirection: textDirection,
          children: [
            Icon(
              _iconFor(method.name),
              color: isSelected
                  ? colors.primary
                  : colors.muted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                method.displayName,
                textAlign: textAlign,
                style:
                tokens.typography.bodyMedium.copyWith(
                  color: isSelected
                      ? colors.primary
                      : colors.label,
                  fontWeight: isSelected
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ),
            Radio<String>(
              value: method.name,
              groupValue:
              isSelected ? method.name : null,
              activeColor: colors.primary,
              onChanged: (_) => onTap(),
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name.toUpperCase()) {
      case 'CASH':
        return Icons.payments_outlined;

      case 'STRIPE':
        return Icons.credit_card_outlined;

      case 'PAYPAL':
        return Icons.account_balance_wallet_outlined;

      default:
        return Icons.payment_outlined;
    }
  }
}

class _CheckoutResultSheet extends StatelessWidget {
  final CheckoutResultEntity result;
  final dynamic tokens;

  const _CheckoutResultSheet({
    required this.result,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final colors = tokens.colors;
    final isPending = result.isPending;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isPending
                    ? const Color(0xFFFFF3CD)
                    : colors.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPending
                    ? Icons.hourglass_top_rounded
                    : Icons.check_circle_outline,
                color: isPending
                    ? const Color(0xFF856404)
                    : colors.success,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isPending
                  ? l10n.paymentSheetPendingConfirmationTitle
                  : l10n.planSubscriptionSuccessTitle,
              textAlign: TextAlign.center,
              style:
              tokens.typography.headlineSmall.copyWith(
                color: colors.label,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPending
                  ? l10n.planSubscriptionPendingMessage
                  : l10n.planSubscriptionActivatedMessage(
                result.planName,
              ),
              textAlign: TextAlign.center,
              style:
              tokens.typography.bodyMedium.copyWith(
                color: colors.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _InfoRow(
              label: l10n.planLabel,
              value: result.planName,
              tokens: tokens,
            ),
            _InfoRow(
              label: l10n.totalAmount,
              value:
              '\$ ${result.totalAmount.toStringAsFixed(2)}',
              tokens: tokens,
            ),
            _InfoRow(
              label: l10n.admin_plans_startDate,
              value: result.startDate,
              tokens: tokens,
            ),
            _InfoRow(
              label: l10n.admin_plans_endDate,
              value: result.endDate,
              tokens: tokens,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l10n.paymentSheetOkButton,
                  style:
                  tokens.typography.bodyMedium.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final dynamic tokens;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final colors = tokens.colors;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    final labelText = Text(
      label,
      textAlign: textAlign,
      style: tokens.typography.bodyMedium.copyWith(
        color: colors.muted,
        fontWeight: FontWeight.w500,
      ),
    );

    final valueText = Text(
      value,
      textAlign: textAlign,
      style: tokens.typography.bodyMedium.copyWith(
        color: colors.label,
        fontWeight: FontWeight.w700,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        textDirection: textDirection,
        children: [
          labelText,
          const Spacer(),
          valueText,
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final String planName;

  const _HeaderTitle({
    required this.planName,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    return Row(
      textDirection: textDirection,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor:
          tokens.colors.onPrimary.withOpacity(0.18),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              isRtl
                  ? Icons.arrow_forward_rounded
                  : Icons.arrow_back_rounded,
              color: tokens.colors.onPrimary,
              size: 22,
            ),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            planName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
            style:
            tokens.typography.headlineSmall.copyWith(
              color: tokens.colors.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutPlanCard extends StatelessWidget {
  final PlanDetailEntity plan;
  final CouponValidationEntity? coupon;

  const _CheckoutPlanCard({
    required this.plan,
    required this.coupon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final symbol =
        context.watch<CurrencyCubit>().state.info.symbol;

    final baseDisplayPrice = plan.displayPrice;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    final crossAxisAlignment = isRtl
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    final finalPrice =
    coupon?.valid == true &&
        coupon?.finalPrice != null
        ? coupon!.finalPrice!
        : baseDisplayPrice;

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: textDirection,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  crossAxisAlignment,
                  children: [
                    Text(
                      l10n.selectedPlan,
                      textAlign: textAlign,
                      style:
                      tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plan.name,
                      textAlign: textAlign,
                      style:
                      tokens.typography.titleMedium.copyWith(
                        color: tokens.colors.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _billingCycleLabel(
                        l10n,
                        plan.billingCycle,
                      ),
                      textAlign: textAlign,
                      style:
                      tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '$symbol ${finalPrice == finalPrice.truncateToDouble() ? finalPrice.toInt() : finalPrice.toStringAsFixed(2)}',
                  style: tokens
                      .typography.headlineSmall
                      .copyWith(
                    color: tokens.colors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          if (plan.description != null &&
              plan.description!.trim().isNotEmpty) ...[
            SizedBox(
              height: tokens.spacing.lg,
            ),
            Text(
              plan.description!,
              textAlign: textAlign,
              style:
              tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.body,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
          SizedBox(
            height: tokens.spacing.lg,
          ),
          Divider(
            color:
            tokens.colors.border.withOpacity(0.32),
          ),
          SizedBox(
            height: tokens.spacing.md,
          ),
          _SummaryRow(
            label: l10n.baseAmount,
            value:
            '$symbol ${plan.price.toStringAsFixed(2)}',
          ),
          if (plan.hasActivePromotion) ...[
            SizedBox(
              height: tokens.spacing.sm,
            ),
            _SummaryRow(
              label: l10n.promotionPrice,
              value:
              '$symbol ${plan.displayPrice.toStringAsFixed(2)}',
              highlighted: true,
            ),
          ],
          SizedBox(
            height: tokens.spacing.sm,
          ),
          _SummaryRow(
            label: l10n.totalAmount,
            value:
            '$symbol ${finalPrice.toStringAsFixed(2)}',
            highlighted: true,
          ),
        ],
      ),
    );
  }

  String _billingCycleLabel(
      AppLocalizations l10n,
      String value,
      ) {
    switch (value.toLowerCase().trim()) {
      case 'monthly':
        return l10n.billingMonthly;

      case 'yearly':
        return l10n.billingYearly;

      case 'weekly':
        return l10n.billingWeekly;

      default:
        return value;
    }
  }
}

class _CouponCard extends StatelessWidget {
  final int planId;
  final TextEditingController couponController;
  final CouponValidationEntity? coupon;
  final bool isCouponValidating;

  const _CouponCard({
    required this.planId,
    required this.couponController,
    required this.coupon,
    required this.isCouponValidating,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: textDirection,
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: tokens.colors.primary,
                size: 22,
              ),
              SizedBox(
                width: tokens.spacing.sm,
              ),
              Expanded(
                child: Text(
                  l10n.couponCode,
                  textAlign: textAlign,
                  style: tokens
                      .typography.titleMedium
                      .copyWith(
                    color: tokens.colors.label,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: tokens.spacing.md,
          ),
          Row(
            textDirection: textDirection,
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  textAlign: textAlign,
                  textDirection: textDirection,
                  decoration: InputDecoration(
                    hintText: l10n.enterCouponCode,
                    hintTextDirection: textDirection,
                    filled: true,
                    fillColor:
                    tokens.colors.background,
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: isCouponValidating
                      ? null
                      : () {
                    final code =
                    couponController.text.trim();

                    if (code.isEmpty) return;

                    context
                        .read<PlanDetailBloc>()
                        .add(
                      ApplyCouponEvent(
                        couponCode: code,
                        planId: planId,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.primary
                        .withOpacity(0.45),
                    foregroundColor:
                    tokens.colors.onPrimary,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                  child: isCouponValidating
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                      tokens.colors.onPrimary,
                    ),
                  )
                      : Text(
                    l10n.apply,
                    style: tokens
                        .typography.bodyMedium
                        .copyWith(
                      color:
                      tokens.colors.onPrimary,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (coupon != null) ...[
            SizedBox(
              height: tokens.spacing.sm,
            ),
            Text(
              coupon!.valid
                  ? l10n.couponAppliedFinalPrice(
                coupon!.finalPrice
                    ?.toStringAsFixed(2) ??
                    '-',
              )
                  : coupon!.message,
              textAlign: textAlign,
              textDirection: textDirection,
              style:
              tokens.typography.bodyMedium.copyWith(
                color: coupon!.valid
                    ? tokens.colors.success
                    : tokens.colors.danger,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final textDirection =
    isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textAlign =
    isRtl ? TextAlign.right : TextAlign.left;

    final labelText = Text(
      label,
      textAlign: textAlign,
      style: tokens.typography.bodyMedium.copyWith(
        color: highlighted
            ? tokens.colors.label
            : tokens.colors.muted,
        fontWeight: highlighted
            ? FontWeight.w900
            : FontWeight.w600,
      ),
    );

    final valueText = Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        value,
        style: tokens.typography.bodyMedium.copyWith(
          color: highlighted
              ? tokens.colors.primary
              : tokens.colors.body,
          fontWeight: highlighted
              ? FontWeight.w900
              : FontWeight.w600,
        ),
      ),
    );

    return Row(
      textDirection: textDirection,
      children: [
        labelText,
        const Spacer(),
        valueText,
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        tokens.spacing.lg,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
          tokens.colors.border.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color:
            tokens.colors.label.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}