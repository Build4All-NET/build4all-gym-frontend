// =============================================================================
// FILE: membership_package_widget.dart
// PATH: lib/features/admin/members/presentation/widgets/membership_package_widget.dart
// TASK: GA-272
// =============================================================================

import 'package:flutter/material.dart';

import '../../domain/entities/membership_package_entity.dart';
import '../../../../../l10n/app_localizations.dart';

class MembershipPackageWidget extends StatelessWidget {
  const MembershipPackageWidget({super.key, required this.package});

  final MembershipPackageEntity package;

  @override
  Widget build(BuildContext context) {
    final cs   = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.admin_members_membershipPackageTitle,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // ── Rows with dividers ─────────────────────────────────────────────
          _PackageRow(
            label: l10n.admin_members_packagePlanName,
            value: package.planName ?? '—',
            cs:    cs,
          ),
          _divider(cs),
          _PackageRow(
            label: l10n.admin_members_packageTotalAmount,
            value: '₹${package.totalAmount.toStringAsFixed(0)}',
            cs:    cs,
          ),
          _divider(cs),
          _PackageRow(
            label:      l10n.admin_members_packageDiscount,
            value:      '- ₹${package.discountAmount.toStringAsFixed(0)}',
            valueColor: const Color(0xFF4ADE80),
            cs:         cs,
          ),
          _divider(cs),
          _PackageRow(
            label: l10n.admin_members_packagePurchaseDate,
            value: package.purchaseDate ?? '—',
            cs:    cs,
          ),
          _divider(cs),
          _PackageRow(
            label:      l10n.admin_members_packagePaidAmount,
            value:      '₹${package.paidAmount.toStringAsFixed(0)}',
            valueColor: const Color(0xFF60A5FA),
            cs:         cs,
          ),
          _divider(cs),
          _PackageRow(
            label:      l10n.admin_members_packageDueAmount,
            value:      '₹${package.dueAmount.toStringAsFixed(0)}',
            valueColor: package.hasDues ? const Color(0xFFEF4444) : null,
            cs:         cs,
          ),
          _divider(cs),
          _PackageRow(
            label:      l10n.admin_members_packageRemainingDays,
            value:      l10n.admin_members_packageDays(package.remainingDays),
            valueColor: package.isExpired
                ? const Color(0xFFEF4444)
                : const Color(0xFF4ADE80),
            cs:         cs,
          ),
        ],
      ),
    );
  }

  Widget _divider(ColorScheme cs) => Divider(
    color: cs.outline.withOpacity(0.15),
    height: 24,
  );
}

// ---------------------------------------------------------------------------
// Single label-value row — value is right-aligned, supports RTL naturally.
// ---------------------------------------------------------------------------
class _PackageRow extends StatelessWidget {
  const _PackageRow({
    required this.label,
    required this.value,
    required this.cs,
    this.valueColor,
  });

  final String      label;
  final String      value;
  final ColorScheme cs;
  final Color?      valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color:    cs.onSurface.withOpacity(0.55),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color:      valueColor ?? cs.onSurface,
            fontSize:   13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}