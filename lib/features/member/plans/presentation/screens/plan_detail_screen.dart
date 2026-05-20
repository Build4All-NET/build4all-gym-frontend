import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../data/repositories/member_plans_repository_impl.dart';
import '../../data/services/member_plans_remote_datasource.dart';
import '../../domain/entities/coupon_validation_entity.dart';
import '../../domain/entities/plan_detail_entity.dart';
import '../../domain/usecases/get_plan_detail_usecase.dart';
import '../../domain/usecases/validate_coupon_usecase.dart';
import '../bloc/plan_detail/plan_detail_bloc.dart';
import '../bloc/plan_detail/plan_detail_event.dart';
import '../bloc/plan_detail/plan_detail_state.dart';


 // ________________________note : this code not ready , payment ___________________________________
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
        getPlanDetail: GetPlanDetailUseCase(repository: repository),
        validateCoupon: ValidateCouponUseCase(repository: repository),
      )..add(LoadPlanDetailEvent(planId: planId)),
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<PlanDetailBloc, PlanDetailState>(
        builder: (context, state) {
          if (state is PlanDetailLoading) {
            return Scaffold(
              backgroundColor: tokens.colors.background,
              body: Center(
                child: CircularProgressIndicator(
                  color: tokens.colors.primary,
                ),
              ),
            );
          }

          if (state is PlanDetailError) {
            return Scaffold(
              backgroundColor: tokens.colors.background,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
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

          if (state is PlanDetailLoaded) {
            final plan = state.plan;
            final bool isBooked = plan.isBooked;
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
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _HeaderTitle(planName: plan.name),
                          const SizedBox(height: 28),

                          _CheckoutPlanCard(
                            plan: plan,
                            coupon: state.coupon,
                          ),

                          SizedBox(height: tokens.spacing.lg),

                          _CouponCard(
                            planId: widget.planId,
                            couponController: _couponController,
                            coupon: state.coupon,
                            isCouponValidating: state.isCouponValidating,
                          ),

                          SizedBox(height: tokens.spacing.lg),

                          const _PaymentMethodCard(),

                          SizedBox(height: tokens.spacing.xl),

                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              // TODO: replace with checkout navigation when payment screen is ready.
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.checkoutComingSoon),
                                    backgroundColor: tokens.colors.primary,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tokens.colors.primary,
                                foregroundColor: tokens.colors.onPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                l10n.selectThisPlan,
                                style: tokens.typography.bodyMedium.copyWith(
                                  color: tokens.colors.onPrimary,
                                  fontWeight: FontWeight.w900,
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

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: tokens.colors.onPrimary.withOpacity(0.18),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
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
            textAlign: TextAlign.right,
            style: tokens.typography.headlineSmall.copyWith(
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

    final finalPrice = coupon?.valid == true && coupon?.finalPrice != null
        ? coupon!.finalPrice!
        : plan.price;

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.selectedPlan,
                      textAlign: TextAlign.right,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plan.name,
                      textAlign: TextAlign.right,
                      style: tokens.typography.titleMedium.copyWith(
                        color: tokens.colors.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _billingCycleLabel(l10n, plan.billingCycle),
                      textAlign: TextAlign.right,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '\$ ${plan.price.toStringAsFixed(0)}',
                style: tokens.typography.headlineSmall.copyWith(
                  color: tokens.colors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          if (plan.description != null &&
              plan.description!.trim().isNotEmpty) ...[
            SizedBox(height: tokens.spacing.lg),
            Text(
              plan.description!,
              textAlign: TextAlign.right,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.body,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],

          SizedBox(height: tokens.spacing.lg),
          Divider(color: tokens.colors.border.withOpacity(0.32)),
          SizedBox(height: tokens.spacing.md),

          _SummaryRow(
            label: l10n.baseAmount,
            value: '\$ ${plan.price.toStringAsFixed(2)}',
          ),
          SizedBox(height: tokens.spacing.sm),
          _SummaryRow(
            label: l10n.totalAmount,
            value: '\$ ${finalPrice.toStringAsFixed(2)}',
            highlighted: true,
          ),
        ],
      ),
    );
  }

  String _billingCycleLabel(AppLocalizations l10n, String value) {
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

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: tokens.colors.primary,
                size: 22,
              ),
              SizedBox(width: tokens.spacing.sm),
              Text(
                l10n.couponCode,
                textAlign: TextAlign.right,
                style: tokens.typography.titleMedium.copyWith(
                  color: tokens.colors.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          SizedBox(height: tokens.spacing.md),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: l10n.enterCouponCode,
                    filled: true,
                    fillColor: tokens.colors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
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
                    final code = couponController.text.trim();
                    if (code.isEmpty) return;

                    context.read<PlanDetailBloc>().add(
                      ApplyCouponEvent(
                        couponCode: code,
                        planId: planId,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.primary.withOpacity(0.45),
                    foregroundColor: tokens.colors.onPrimary,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isCouponValidating
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: tokens.colors.onPrimary,
                    ),
                  )
                      : Text(
                    l10n.apply,
                    style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.onPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (coupon != null) ...[
            SizedBox(height: tokens.spacing.sm),
            Text(
              coupon!.valid
                  ? l10n.couponAppliedFinalPrice(
                coupon!.finalPrice?.toStringAsFixed(2) ?? '-',
              )
                  : coupon!.message,
              textAlign: TextAlign.right,
              style: tokens.typography.bodyMedium.copyWith(
                color:
                coupon!.valid ? tokens.colors.success : tokens.colors.danger,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return _WhiteCard(
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.credit_card_rounded,
            color: tokens.colors.primary,
            size: 24,
          ),
          SizedBox(width: tokens.spacing.sm),
          Expanded(
            child: Text(
              'Cash / Card عند الاستقبال',
              textAlign: TextAlign.right,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
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

    return Row(
      children: [
        Text(
          value,
          style: tokens.typography.bodyMedium.copyWith(
            color: highlighted ? tokens.colors.primary : tokens.colors.body,
            fontWeight: highlighted ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          label,
          textAlign: TextAlign.right,
          style: tokens.typography.bodyMedium.copyWith(
            color: highlighted ? tokens.colors.label : tokens.colors.muted,
            fontWeight: highlighted ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
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
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: tokens.colors.border.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}