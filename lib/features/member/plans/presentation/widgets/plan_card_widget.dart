import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/currency/currency_cubit.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../domain/entities/plan_entity.dart';

class PlanCardWidget extends StatelessWidget {
  final PlanEntity plan;
  final VoidCallback onSelectPlan;

  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final bool featured = plan.isFeatured;
    final bool isBooked = plan.isBooked;
    final promotion = plan.activePromotion;

    final bool hasPromotion =
        promotion != null &&
            promotion.finalPrice > 0 &&
            promotion.finalPrice < plan.price;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;
    final textAlign = isRtl ? TextAlign.end : TextAlign.start;
    final crossAxis = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      margin: EdgeInsets.only(bottom: tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: featured
              ? tokens.colors.primary
              : tokens.colors.border.withOpacity(0.18),
          width: featured ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (featured)
            Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tokens.colors.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Text(
                isRtl ? '⭐ ${l10n.mostPopular}' : '${l10n.mostPopular} ⭐',
                style: tokens.typography.bodyMedium.copyWith(
                  color: tokens.colors.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  textDirection: textDirection,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: crossAxis,
                        children: [
                          Text(
                            plan.name,
                            textAlign: textAlign,
                            style: tokens.typography.headlineSmall.copyWith(
                              color: tokens.colors.label,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 10),

                          _PriceBlock(
                            originalPrice: plan.price,
                            finalPrice: hasPromotion && promotion != null
                                ? promotion.finalPrice
                                : plan.price,
                            billingCycle: _localizedBillingCycle(
                              l10n,
                              plan.billingCycle,
                            ),
                            hasPromotion: hasPromotion,
                            isRtl: isRtl,
                          ),

                          const SizedBox(height: 14),

                          if (hasPromotion && promotion != null) ...[
                            _PromotionBanner(
                              promotion: promotion,
                              textDirection: textDirection,
                              textAlign: textAlign,
                            ),
                            const SizedBox(height: 14),
                          ],

                          ...plan.features.map(
                                (feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                textDirection: textDirection,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color:
                                      tokens.colors.primary.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: tokens.colors.primary,
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      feature,
                                      textAlign: textAlign,
                                      style:
                                      tokens.typography.bodyMedium.copyWith(
                                        color: tokens.colors.label,
                                        fontWeight: FontWeight.w500,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    _PlanIcon(iconName: plan.iconName),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isBooked ? null : onSelectPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBooked
                          ? tokens.colors.border.withOpacity(0.35)
                          : featured
                          ? tokens.colors.primary
                          : const Color(0xFFEAF0F8),
                      foregroundColor: isBooked
                          ? tokens.colors.muted
                          : featured
                          ? tokens.colors.onPrimary
                          : tokens.colors.label,
                      disabledBackgroundColor:
                      tokens.colors.border.withOpacity(0.35),
                      disabledForegroundColor: tokens.colors.muted,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isBooked ? l10n.booked : l10n.selectThisPlan,
                      style: tokens.typography.bodyMedium.copyWith(
                        color: isBooked
                            ? tokens.colors.muted
                            : featured
                            ? tokens.colors.onPrimary
                            : tokens.colors.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizedBillingCycle(AppLocalizations l10n, String value) {
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

class _PriceBlock extends StatelessWidget {
  final double originalPrice;
  final double finalPrice;
  final String billingCycle;
  final bool hasPromotion;
  final bool isRtl;

  const _PriceBlock({
    required this.originalPrice,
    required this.finalPrice,
    required this.billingCycle,
    required this.hasPromotion,
    required this.isRtl,
  });

  String _fmt(double price, String symbol) {
    final isWhole = price == price.truncateToDouble();
    return '$symbol${isWhole ? price.toInt() : price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final symbol = context.watch<CurrencyCubit>().state.info.symbol;

    return Align(
      alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 8,
          runSpacing: 4,
          children: [
            // Sale price first.
            Text(
              _fmt(finalPrice, symbol),
              textDirection: TextDirection.ltr,
              style: tokens.typography.headlineSmall.copyWith(
                color: hasPromotion
                    ? tokens.colors.success
                    : tokens.colors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 30,
                height: 1,
              ),
            ),

            // Real price second, crossed.
            if (hasPromotion)
              Text(
                _fmt(originalPrice, symbol),
                textDirection: TextDirection.ltr,
                style: tokens.typography.headlineSmall.copyWith(
                  color: tokens.colors.muted,
                  fontWeight: FontWeight.w900,
                  fontSize: 23,
                  height: 1,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2.2,
                ),
              ),

            Text(
              '/ $billingCycle',
              textDirection: TextDirection.ltr,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.muted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromotionBanner extends StatelessWidget {
  final ActivePromotionEntity promotion;
  final TextDirection textDirection;
  final TextAlign textAlign;

  const _PromotionBanner({
    required this.promotion,
    required this.textDirection,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.colors.success.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tokens.colors.success.withOpacity(0.35),
        ),
      ),
      child: Row(
        textDirection: textDirection,
        children: [
          Icon(
            Icons.local_offer_rounded,
            color: tokens.colors.success,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _promotionLabel(promotion),
              textAlign: textAlign,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.bodySmall.copyWith(
                color: tokens.colors.success,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _promotionLabel(ActivePromotionEntity promotion) {
    final discountType = promotion.discountType.toLowerCase().trim();
    final value = promotion.discountValue;

    if (discountType == 'percentage') {
      return '${promotion.title} - ${value.toStringAsFixed(0)}% OFF';
    }

    if (discountType == 'fixed') {
      return '${promotion.title} - \$${value.toStringAsFixed(0)} OFF';
    }

    return promotion.title;
  }
}

class _PlanIcon extends StatelessWidget {
  final String? iconName;

  const _PlanIcon({
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    final iconKey = iconName?.toLowerCase().trim() ?? '';

    final icon = _iconByName(iconKey);
    final color = _colorByName(iconKey, tokens);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: tokens.colors.onPrimary,
        size: 24,
      ),
    );
  }

  IconData _iconByName(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star_border_rounded;
      case 'crown':
        return Icons.workspace_premium_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'gym':
      case 'dumbbell':
        return Icons.fitness_center_rounded;
      case 'classes':
      case 'calendar':
        return Icons.event_available_rounded;
      case 'vip':
        return Icons.diamond_rounded;
      default:
        return Icons.star_border_rounded;
    }
  }

  Color _colorByName(String iconName, dynamic tokens) {
    switch (iconName) {
      case 'crown':
        return Colors.orange;
      case 'bolt':
        return Colors.purple;
      case 'vip':
        return Colors.indigo;
      case 'gym':
      case 'dumbbell':
        return tokens.colors.primary;
      case 'classes':
      case 'calendar':
        return Colors.blueGrey;
      default:
        return Colors.blueGrey;
    }
  }
}