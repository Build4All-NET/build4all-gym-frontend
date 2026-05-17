import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_plan_list_item_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';

class AdminPlanCardWidget extends StatelessWidget {
  final AdminPlanListItemEntity plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const AdminPlanCardWidget({
    super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final card = tokens.card;

    return Opacity(
      opacity: plan.isActive ? 1.0 : 0.65,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(card.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top row: name + badges ────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(plan.name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: c.label)),
                        _PillBadge(
                          label: plan.planType,
                          color: c.border.withOpacity(0.15),
                          textColor: c.muted,
                        ),
                        if (plan.isFeatured)
                          const _PillBadge(
                            label: 'Featured',
                            color: Color(0xFFFFF3CD),
                            textColor: Color(0xFF856404),
                            icon: Icons.star_rounded,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PillBadge(
                    label: plan.isActive ? 'Active' : 'Inactive',
                    color: plan.isActive
                        ? c.success.withOpacity(0.12)
                        : c.border.withOpacity(0.15),
                    textColor: plan.isActive ? c.success : c.muted,
                  ),
                ],
              ),

              // ── Description ───────────────────────────────────────────────
              if (plan.description != null) ...[
                const SizedBox(height: 6),
                Text(plan.description!,
                    style: TextStyle(
                        fontSize: 13, color: c.body, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],

              const SizedBox(height: 14),
              Divider(height: 1, color: c.border.withOpacity(0.15)),
              const SizedBox(height: 14),

              // ── Row 1: Price | Duration ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.attach_money_rounded,
                      label: 'Price',
                      value: '₹${plan.price.toStringAsFixed(0)}',
                      c: c,
                    ),
                  ),
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.calendar_today_outlined,
                      label: 'Duration',
                      value: _formatCycle(plan.billingCycle),
                      c: c,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 2: Members | Visit Limit ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.people_outline_rounded,
                      label: 'Members',
                      value: plan.memberCount.toString(),
                      c: c,
                    ),
                  ),
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Visit Limit',
                      value: plan.allowedVisits != null
                          ? plan.allowedVisits.toString()
                          : 'Unlimited',
                      c: c,
                    ),
                  ),
                ],
              ),

              // ── Row 3: Freeze Days | Max Freezes ─────────────────────────
              if (plan.freezeDaysAllowance != null ||
                  plan.maxFreezesCount != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (plan.freezeDaysAllowance != null)
                      Expanded(
                        child: _DetailCell(
                          icon: Icons.ac_unit_rounded,
                          label: 'Freeze Days',
                          value: '${plan.freezeDaysAllowance}d',
                          c: c,
                          iconColor: Colors.lightBlue,
                        ),
                      ),
                    if (plan.maxFreezesCount != null)
                      Expanded(
                        child: _DetailCell(
                          icon: Icons.repeat_rounded,
                          label: 'Max Freezes',
                          value: plan.maxFreezesCount.toString(),
                          c: c,
                          iconColor: Colors.lightBlue,
                        ),
                      ),
                  ],
                ),
              ],

              // ── Row 4: Grace Period | Auto Renew ─────────────────────────
              if (plan.gracePeriodDays != null || plan.autoRenew) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (plan.gracePeriodDays != null)
                      Expanded(
                        child: _DetailCell(
                          icon: Icons.hourglass_bottom_rounded,
                          label: 'Grace Period',
                          value: '${plan.gracePeriodDays}d',
                          c: c,
                        ),
                      ),
                    if (plan.autoRenew)
                      Expanded(
                        child: _DetailCell(
                          icon: Icons.autorenew_rounded,
                          label: 'Auto Renew',
                          value: 'On',
                          c: c,
                          iconColor: c.success,
                          valueColor: c.success,
                        ),
                      ),
                  ],
                ),
              ],

              // ── Plan Features ─────────────────────────────────────────────
              if (plan.features.isNotEmpty) ...[
                const SizedBox(height: 14),
                Divider(height: 1, color: c.border.withOpacity(0.15)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        size: 13, color: c.muted),
                    const SizedBox(width: 5),
                    Text('Included Features',
                        style: TextStyle(
                            fontSize: 11,
                            color: c.muted,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: plan.features.map((f) {
                    final label = f.featureValue != null &&
                            f.featureValue!.isNotEmpty
                        ? '${f.featureName}: ${f.featureValue}'
                        : f.featureName;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: c.success.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: c.success.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded,
                              size: 11, color: c.success),
                          const SizedBox(width: 4),
                          Text(label,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: c.label,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              // ── Promotion ─────────────────────────────────────────────────
              if (plan.promotion != null) ...[
                const SizedBox(height: 14),
                Divider(height: 1, color: c.border.withOpacity(0.15)),
                const SizedBox(height: 10),
                _PromotionBanner(promotion: plan.promotion!, c: c),
              ] else if (plan.promotionText != null) ...[
                // fallback: only title available
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.local_offer_rounded,
                        size: 13,
                        color: Color.lerp(c.danger, c.primary, 0.3)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(plan.promotionText!,
                          style: TextStyle(
                              fontSize: 12,
                              color:
                                  Color.lerp(c.danger, c.primary, 0.3),
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],

              // ── Branches ──────────────────────────────────────────────────
              if (plan.branches.isNotEmpty) ...[
                const SizedBox(height: 14),
                Divider(height: 1, color: c.border.withOpacity(0.15)),
                const SizedBox(height: 10),
                Text('Available at:',
                    style: TextStyle(
                        fontSize: 11,
                        color: c.muted,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: plan.branches
                      .map((b) => _PillBadge(
                            label: b,
                            color: c.border.withOpacity(0.12),
                            textColor: c.body,
                            fontSize: 11,
                          ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 14),
              Divider(height: 1, color: c.border.withOpacity(0.15)),
              const SizedBox(height: 12),

              // ── Action buttons ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: const Text('Edit',
                          style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.body,
                        side: BorderSide(
                            color: c.border.withOpacity(0.4)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isDeleting ? null : onDelete,
                      icon: isDeleting
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: c.danger),
                            )
                          : const Icon(
                              Icons.delete_outline_rounded,
                              size: 15),
                      label: Text(
                          isDeleting ? 'Deleting...' : 'Delete',
                          style: const TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.danger,
                        side: BorderSide(color: c.danger),
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCycle(String cycle) => switch (cycle.toLowerCase()) {
        'monthly' => '1 month',
        'quarterly' => '3 months',
        'yearly' => '1 year',
        'one_time' || 'one-time' => 'One time',
        _ => cycle,
      };
}

// ─────────────────────────────────────────────────────────────────────────────

class _PromotionBanner extends StatelessWidget {
  final dynamic promotion; // PlanPromotionEntity
  final dynamic c;         // ColorTokens

  const _PromotionBanner({required this.promotion, required this.c});

  @override
  Widget build(BuildContext context) {
    final promoColor = Color.lerp(c.danger, c.primary, 0.3)!;

    String discountLabel = '';
    if (promotion.discountValue > 0) {
      discountLabel = promotion.discountType == 'percentage'
          ? '${promotion.discountValue.toStringAsFixed(0)}% off'
          : '₹${promotion.discountValue.toStringAsFixed(0)} off';
    }

    String dateLabel = '';
    if (promotion.startDate != null && promotion.endDate != null) {
      final fmt = (DateTime d) =>
          '${d.day}/${d.month}/${d.year}';
      dateLabel =
          '${fmt(promotion.startDate!)} – ${fmt(promotion.endDate!)}';
    } else if (promotion.endDate != null) {
      final d = promotion.endDate!;
      dateLabel = 'Until ${d.day}/${d.month}/${d.year}';
    } else {
      dateLabel = 'Open-ended';
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: promoColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: promoColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_rounded,
                  size: 13, color: promoColor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(promotion.title,
                    style: TextStyle(
                        fontSize: 13,
                        color: promoColor,
                        fontWeight: FontWeight.w600)),
              ),
              if (discountLabel.isNotEmpty) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: promoColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(discountLabel,
                      style: TextStyle(
                          fontSize: 11,
                          color: promoColor,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
          if (promotion.description != null &&
              promotion.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(promotion.description!,
                style: TextStyle(
                    fontSize: 11, color: c.muted, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 11, color: c.muted),
              const SizedBox(width: 4),
              Text(dateLabel,
                  style:
                      TextStyle(fontSize: 11, color: c.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DetailCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final dynamic c; // ColorTokens
  final Color? iconColor;
  final Color? valueColor;

  const _DetailCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.c,
    this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: iconColor ?? c.muted),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: c.muted,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? c.label)),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final double fontSize;
  final IconData? icon;

  const _PillBadge({
    required this.label,
    required this.color,
    required this.textColor,
    this.fontSize = 12,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
