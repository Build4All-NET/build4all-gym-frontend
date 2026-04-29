import 'package:flutter/material.dart';
import '../../domain/entities/admin_plan_list_item_entity.dart';

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
    return Opacity(
      opacity: plan.isActive ? 1.0 : 0.65,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              // ── TOP ROW: name + type badge | active badge ─────────────
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
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _PillBadge(
                          label: plan.planType,
                          color: const Color(0xFFF3F4F6),
                          textColor: const Color(0xFF6B7280),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PillBadge(
                    label: plan.isActive ? 'Active' : 'Inactive',
                    color: plan.isActive
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFF3F4F6),
                    textColor: plan.isActive
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF9CA3AF),
                  ),
                ],
              ),

              // ── PROMOTION ─────────────────────────────────────────────
              if (plan.promotionText != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_offer_rounded,
                        size: 13, color: Color(0xFFEC4899)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        plan.promotionText!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEC4899),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // ── DESCRIPTION ───────────────────────────────────────────
              if (plan.description != null) ...[
                const SizedBox(height: 6),
                Text(
                  plan.description!,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              const SizedBox(height: 14),

              // ── DETAILS GRID ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.attach_money_rounded,
                      label: 'Price',
                      value: '₹${plan.price.toStringAsFixed(0)}',
                    ),
                  ),
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.calendar_today_outlined,
                      label: 'Duration',
                      value: _formatBillingCycle(plan.billingCycle),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.people_outline_rounded,
                      label: 'Members',
                      value: plan.memberCount.toString(),
                    ),
                  ),
                  Expanded(
                    child: _DetailCell(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Visit Limit',
                      value: plan.allowedVisits != null
                          ? plan.allowedVisits.toString()
                          : 'Unlimited',
                    ),
                  ),
                ],
              ),

              // ── BRANCHES ──────────────────────────────────────────────
              if (plan.branches.isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text(
                  'Available at:',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: plan.branches
                      .map((b) => _PillBadge(
                    label: b,
                    color: const Color(0xFFF3F4F6),
                    textColor: const Color(0xFF374151),
                    fontSize: 11,
                  ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              const SizedBox(height: 12),

              // ── ACTION BUTTONS ────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: const Text('Edit',
                          style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF374151),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isDeleting ? null : onDelete,
                      icon: isDeleting
                          ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFDC2626),
                        ),
                      )
                          : const Icon(Icons.delete_outline_rounded,
                          size: 15),
                      label: Text(
                        isDeleting ? 'Deleting...' : 'Delete',
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
      'monthly' => '1 month',
      'quarterly' => '3 months',
      'yearly' => '1 year',
      'one_time' => 'One time',
      _ => cycle,
    };
  }
}

// ── Detail cell: icon + label on top, value below ──────────────────────────

class _DetailCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: const Color(0xFF9CA3AF)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

// ── Pill badge ─────────────────────────────────────────────────────────────

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
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
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}