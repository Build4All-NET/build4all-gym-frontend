import 'package:flutter/material.dart';
import '../../domain/entities/admin_plan_list_item_entity.dart';

/// One plan card in the admin list.
/// Shows all plan info + Edit / Delete buttons.
class AdminPlanCardWidget extends StatelessWidget {
  final AdminPlanListItemEntity plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting; // shows spinner on delete button

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
      opacity: plan.isActive ? 1.0 : 0.6,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── TOP ROW: name + type badge + active badge ───────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _PillBadge(
                          label: plan.planType,
                          color: Colors.grey[200]!,
                          textColor: Colors.grey[700]!,
                        ),
                      ],
                    ),
                  ),
                  _PillBadge(
                    label: plan.isActive ? 'Active' : 'Inactive',
                    color: plan.isActive
                        ? const Color(0xFFE8F5E9)
                        : Colors.grey[200]!,
                    textColor: plan.isActive
                        ? const Color(0xFF2E7D32)
                        : Colors.grey[600]!,
                  ),
                ],
              ),

              // ── PROMOTION ───────────────────────────────────────────────
              if (plan.promotionText != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_offer,
                        size: 14, color: Color(0xFFFF6D00)),
                    const SizedBox(width: 4),
                    Text(
                      plan.promotionText!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF6D00),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],

              // ── DESCRIPTION ─────────────────────────────────────────────
              if (plan.description != null) ...[
                const SizedBox(height: 6),
                Text(
                  plan.description!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // ── DETAILS ROW 1: price + duration ─────────────────────────
              Row(
                children: [
                  _DetailChip(
                    icon: Icons.attach_money,
                    label: '\$${plan.price.toStringAsFixed(2)}',
                  ),
                  const SizedBox(width: 16),
                  _DetailChip(
                    icon: Icons.calendar_today,
                    label: plan.billingCycle,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── DETAILS ROW 2: members + visit limit ─────────────────────
              Row(
                children: [
                  _DetailChip(
                    icon: Icons.people_outline,
                    label: '${plan.memberCount} Members',
                  ),
                  const SizedBox(width: 16),
                  _DetailChip(
                    icon: Icons.confirmation_number_outlined,
                    label: plan.allowedVisits != null
                        ? '${plan.allowedVisits} Visits'
                        : 'Unlimited',
                  ),
                ],
              ),

              // ── BRANCHES ────────────────────────────────────────────────
              if (plan.branches.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Available at:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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
                    color: const Color(0xFFF5F5F5),
                    textColor: Colors.grey[700]!,
                    fontSize: 11,
                  ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // ── ACTION BUTTONS ───────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1976D2),
                        side: const BorderSide(color: Color(0xFF1976D2)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isDeleting ? null : onDelete,
                      icon: isDeleting
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFD32F2F),
                        ),
                      )
                          : const Icon(Icons.delete_outline, size: 16),
                      label: Text(isDeleting ? 'Deleting...' : 'Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD32F2F),
                        side: const BorderSide(color: Color(0xFFD32F2F)),
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
}

// ── Helper widgets ────────────────────────────────────────────────────────────

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

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
        ),
      ],
    );
  }
}