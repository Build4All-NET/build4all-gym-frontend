// FILE: lib/features/admin/plans/presentation/widgets/admin_plan_card_widget.dart

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
    final c      = tokens.colors;
    final card   = tokens.card;

    return Opacity(
      opacity: plan.isActive ? 1.0 : 0.65,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:        c.surface,
          borderRadius: BorderRadius.circular(card.radius),
          boxShadow: [
            BoxShadow(
              color:     Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset:    const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top row ───────────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            plan.name,
                            style: TextStyle(
                              fontSize:   15,
                              fontWeight: FontWeight.w700,
                              color:      c.label,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _PillBadge(
                          label:     plan.planType,
                          color:     c.border.withOpacity(0.15),
                          textColor: c.muted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PillBadge(
                    label:     plan.isActive ? 'Active' : 'Inactive',
                    color:     plan.isActive
                        ? c.success.withOpacity(0.12)
                        : c.border.withOpacity(0.15),
                    textColor: plan.isActive ? c.success : c.muted,
                  ),
                ],
              ),

              // ── Promotion ─────────────────────────────────────────────────
              if (plan.promotionText != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_offer_rounded,
                        size: 13,
                        color: Color.lerp(c.danger, c.primary, 0.3)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        plan.promotionText!,
                        style: TextStyle(
                          fontSize:   12,
                          color:      Color.lerp(c.danger, c.primary, 0.3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // ── Description ───────────────────────────────────────────────
              if (plan.description != null) ...[
                const SizedBox(height: 6),
                Text(
                  plan.description!,
                  style: TextStyle(
                      fontSize: 13, color: c.body, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 14),
              Divider(height: 1, color: c.border.withOpacity(0.15)),
              const SizedBox(height: 14),

              // ── Details grid ──────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _DetailCell(
                      icon:      Icons.attach_money_rounded,
                      label:     'Price',
                      value:     '₹${plan.price.toStringAsFixed(0)}',
                      iconColor: c.muted,
                      labelColor: c.muted,
                      valueColor: c.label,
                    ),
                  ),
                  Expanded(
                    child: _DetailCell(
                      icon:       Icons.calendar_today_outlined,
                      label:      'Duration',
                      value:      _formatBillingCycle(plan.billingCycle),
                      iconColor:  c.muted,
                      labelColor: c.muted,
                      valueColor: c.label,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DetailCell(
                      icon:       Icons.people_outline_rounded,
                      label:      'Members',
                      value:      plan.memberCount.toString(),
                      iconColor:  c.muted,
                      labelColor: c.muted,
                      valueColor: c.label,
                    ),
                  ),
                  Expanded(
                    child: _DetailCell(
                      icon:       Icons.confirmation_number_outlined,
                      label:      'Visit Limit',
                      value:      plan.allowedVisits != null
                          ? plan.allowedVisits.toString()
                          : 'Unlimited',
                      iconColor:  c.muted,
                      labelColor: c.muted,
                      valueColor: c.label,
                    ),
                  ),
                ],
              ),

              // ── Branches ──────────────────────────────────────────────────
              if (plan.branches.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Available at:',
                  style: TextStyle(
                      fontSize:   11,
                      color:      c.muted,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing:    6,
                  runSpacing: 6,
                  children: plan.branches
                      .map((b) => _PillBadge(
                    label:     b,
                    color:     c.border.withOpacity(0.12),
                    textColor: c.body,
                    fontSize:  11,
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
                      icon:  const Icon(Icons.edit_outlined, size: 15),
                      label: const Text('Edit',
                          style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.body,
                        side:            BorderSide(
                            color: c.border.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape:   RoundedRectangleBorder(
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
                        width:  15,
                        height: 15,
                        child:  CircularProgressIndicator(
                            strokeWidth: 2, color: c.danger),
                      )
                          : const Icon(Icons.delete_outline_rounded, size: 15),
                      label: Text(
                        isDeleting ? 'Deleting...' : 'Delete',
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.danger,
                        side:            BorderSide(color: c.danger),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape:   RoundedRectangleBorder(
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

  String _formatBillingCycle(String cycle) {
    return switch (cycle.toLowerCase()) {
      'monthly'   => '1 month',
      'quarterly' => '3 months',
      'yearly'    => '1 year',
      'one_time'  => 'One time',
      _           => cycle,
    };
  }
}

class _DetailCell extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    iconColor;
  final Color    labelColor;
  final Color    valueColor;

  const _DetailCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize:   11,
                    color:      labelColor,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w600,
                color:      valueColor)),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color  color;
  final Color  textColor;
  final double fontSize;

  const _PillBadge({
    required this.label,
    required this.color,
    required this.textColor,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize:   fontSize,
            color:      textColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}